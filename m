Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYIYThH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYIYThH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYIYTgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:36:55 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:43466 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753223AbYIYTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:36:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=fhGcbrgvCyZjdKJ6hT+NzwpI/8x3pzoG4SmzSHblN2b/y1/y9HP2HQN67QYql+K99pq80g/1OYMXzxx1mn9YFVUIcbV1+1Ew5iWQE5m6s2HOSvEUYP06yIsWeSAE3XF0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Date: Thu, 25 Sep 2008 12:36:09 -0700
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@gmail.com
References: <20080923.150722.141587696.davem@davemloft.net> <200809251156.10648.jbarnes@virtuousgeek.org> <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251236.12287.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2008 1:22 pm Jiri Kosina wrote:
> On Thu, 25 Sep 2008, Jesse Barnes wrote:
> > > Yes, I think that xorg/xorg i915 driver/libdrm/GEM/whatever are the
> > > biggest suspect currently, according to the data that has been
> > > gathered so far.
> >
> > We have confirmation that this isn't GEM related; according to the
> > Novell bug at https://bugzilla.novell.com/show_bug.cgi?id=425480 people
> > have hit the problem with kernels w/o GEM.
>
> But the xorg intel driver shipped with xorg 7.4 already has support for
> GEM, right? So there could still be some bug in the GEM-aware driver
> running on non-GEM kernel, can't it?

X.Org 7.4 came with xf86-video-intel 2.4.2 right?  That doesn't have any GEM 
bits in it either.

However, the "Factory" log at #425480 *does* indicate that a GEM aware 2D 
driver was loaded (the "[drm:i915_getparam] *ERROR* Unknown parameter 5" 
message indicates as much), but the kernel was definitely not GEM aware 
otherwise the call would have succeeded.  So that rules out GEM proper, but 
it could still be a bug in one of the non-GEM paths in the experimental 
xf86-video-intel bits the various distros seem to be picking up.

> > That doesn't rule out i915 (though I don't think any changes have gone
> > in since 2.6.26 that would have caused this) or xf86-video-intel.  It's
> > possible that X is getting confused about BAR mappings somehow,
> > resulting in a clobbered e1000e NVRAM, but why would the kernel version
> > matter in that case?  The only thing that comes to mind would be PAT...
>
> Yes, booting with 'nopat' is on my list to try immediately after we are
> able to recover the corrupted EEPROM.
>
> > Recent versions of the X drivers (using recent libpciaccess code) will
> > try to map the resourceN_wc file in sysfs.  It's possible that the map
> > size we end up using is wrong, leading to the situation Dave described
> > earlier where we map too much MMIO space.
>
> This we could catch easily even with strace, right?

Yep, that one's easy to catch.

-- 
Jesse Barnes, Intel Open Source Technology Center
