Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXCOSL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXCOSL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXCOSL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:11:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXCOSL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:11:27 -0400
Date: Thu, 15 Mar 2007 14:10:59 -0400
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
Message-ID: <20070315181059.GA1644@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070313040828.GA17893@redhat.com> <200703131022.54322.rjw@sisk.pl> <20070313132218.GA25910@redhat.com> <m1d53apjvu.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d53apjvu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 10:11:01AM -0600, Eric W. Biederman wrote:
 > Dave Jones <davej@redhat.com> writes:
 > 
 > > On Tue, Mar 13, 2007 at 10:22:53AM +0100, Rafael J. Wysocki wrote:
 > >  > On Tuesday, 13 March 2007 05:08, Dave Jones wrote:
 > >  > > I spent considerable time over the last day or so bisecting to
 > >  > > find out why an X60 stopped resuming somewhen between 2.6.20 and current
 > > -git.
 > >  > > (Total lockup, black screen of death).
 > >  > 
 > >  > Do you have CONFIG_TICK_ONESHOT or CONFIG_NO_HZ set?  If you do, could you
 > >  > please unset them and retest?
 > >
 > > I did try with NO_HZ unset, made no difference, I don't recall TICK_ONESHOT.
 > > I'm in meetings all day, but I'll check when I get home.
 > 
 > I haven't heard anything more on this thread.
 > 
 > I just wanted to double check.  The tree that failed did it include
 > commits: 
 > 392ee1e6dd901db6c4504617476f6442ed91f72d and
 > 9f35575dfc172f0a93fb464761883c8f49599b7a
 > 
 > Mostly I was wondering if any of my later work to sort out msi 
 > suspend/resume actually solved anything.

I just did a build of top of tree, including those commits, and
it's still broken.  Booting with pci=nomsi no longer 'fixes' it
though, which may indicate that the MSI changes were a red herring.
(Or that the subsequent changes have regressed it even more,
 which seems unlikely looking at the changes).

.. or it could be something else introduced between rc3 (which is
what my bisect was based on) and todays tree.

sigh. I'll do more bisecting after lunch.

	Dave

-- 
http://www.codemonkey.org.uk
