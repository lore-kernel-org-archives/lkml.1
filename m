Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbYKFWLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbYKFWLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYKFWLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:11:45 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45716 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYKFWLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:11:44 -0500
Date: Thu, 6 Nov 2008 16:11:34 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: mhalcrow@linux.vnet.ibm.com, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler C Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
Subject: Re: [PATCH 0/5] eCryptfs: Filename Encryption
Message-ID: <20081106221134.GE6688@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081105155754.GA1759@ucw.cz> <20081106202736.GC6688@halcrowt61p.austin.ibm.com> <1226004746.8898.6.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226004746.8898.6.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:52:26PM -0600, Dave Kleikamp wrote:
> On Thu, 2008-11-06 at 14:27 -0600, mhalcrow@linux.vnet.ibm.com wrote:
> > On Wed, Nov 05, 2008 at 04:57:54PM +0100, Pavel Machek wrote:
> > > On Tue 2008-11-04 15:37:54, Michael Halcrow wrote:
> > > > This patchset implements filename encryption via a
> > > > passphrase-derived mount-wide Filename Encryption Key (FNEK)
> > > > specified as a mount parameter. Each encrypted filename has a
> > > > fixed prefix indicating that eCryptfs should try to decrypt the
> > > > filename. When eCryptfs encounters
> > > 
> > > That is 'interesting'. What happens if normal filename has that
> > > prefix?
> > 
> > If the lower filename has the prefix but does not have a valid tag
> > 70 packet following the prefix, then eCryptfs will complain in the
> > syslog and then pass through the lower filename as-is.
> 
> I'd recommend hiding this kind of syslog verbosity behind a debug
> config option.  I think it would be very easy to create a DOS attack
> against ecryptfs by putting all sorts of clever things in the lower
> file system.

I instead prefer leaving the default behavior as-is, while perhaps
introducing a module option to suppress such warning messages at the
user's explicit request. In general, I would imagine that the majority
of people would really like to know when a malicious attacker is
managing to write bogus mangled eCryptfs-ish files to their lower
filesystem, even if the means of transmitting the information about
the attack includes the possibility of filling up the syslogs. In
other words, if a malicious party is able to write to your filesystem
under eCryptfs, you probably have much bigger problems to worry about
than just your syslog filling up.

I can imagine some circumstances where filling up the syslog really is
worse than ignoring corrupted eCryptfs files in the lower filesystem,
but I submit that such circumstances are in the minority. I can also
contrive some circumstances where the lower files get mangled through
other non-malicious means, but I do not think such circumstances will
occur frequently enough to justify the risks from staying quiet about
file corruption (malicious or otherwise) in your lower filesystem. So,
if I had to pick a default behavior to do the greatest good for the
greatest number, I would leave the default verbosity where it is,
while providing the admin the option of disabling the verbosity when
encountering mangled lower files.
