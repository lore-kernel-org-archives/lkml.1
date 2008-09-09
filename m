Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYIIEPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYIIEPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbYIIEMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:12:42 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:34159 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756652AbYIIEMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:12:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=jF+6xy6tG60SZvxXmbtC24itSS2dkS3PHGcncrc5O+uP2o/SluZBsTfij+P/S+KtpsLsxvjcwBu+eooAym9aknu21r8iXDPkSu1laPJkDenZ2mjCMPWo32H/mF5sX1GS;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI Hotplug: fakephp: fix deadlock... again
Date: Mon, 8 Sep 2008 21:12:29 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, "Zhao, Yu" <yu.zhao@intel.com>,
       Greg KH <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080902000951.GM1239@parisc-linux.org> <20080902001905.GB14492@ldl.fc.hp.com>
In-Reply-To: <20080902001905.GB14492@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082112.30457.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 12.108.5.2 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 01, 2008 5:19 pm Alex Chiang wrote:
> * Matthew Wilcox <matthew@wil.cx>:
> > On Mon, Sep 01, 2008 at 12:40:18PM -0600, Alex Chiang wrote:
> > > We get the "slot already scheduled for removal" because that
> > > particular device has 2 functions, and we're creating slots
> > > on a per-slot basis now, not a per-function basis.
> > >
> > > Although, I wonder, Willy -- is that really the right thing
> > > to do? Seems like fakephp would be more useful if we did
> > > operate on a per-function basis, and not per-slot. Especially
> > > given Yu's work with SR-IOV, where we can apparently have
> > > lots of functions per a physical device.
> >
> > I suspect it depends on what you believe the point of fakephp
> > is.
>
> Ok, this was all developed before I started working in this area,
> or Linux, even. ;)
>
> > My assumption was that it was a way to fake what would happen
> > if you had a hotplug controller for a particular slot.  In that
> > context, the change I made was clearly correct.  If you want to
> > use it for hot-removing individual functions from a Linux guest
> > running under a hypervisor (for example), that's much less
> > useful.
>
> Sure, that sounds reasonable.
>
> In that case, my patch should fix the stupid regression I
> introduced, but if others think that fakephp would be more useful
> for hot-removing functions, I wouldn't object to reverting the
> original patch.

I don't have a preference here; whatever is most useful for people is probably 
what we should go for.  Zhao?

Thanks,
Jesse

