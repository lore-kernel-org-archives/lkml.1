Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbXH3DOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbXH3DOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXH3DOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:14:31 -0400
Received: from main.gmane.org ([80.91.229.2]:38563 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXH3DOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:14:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Salah Coronya <salahx@yahoo.com>
Subject: Re: Forced unmounting for removable devices
Date: Wed, 29 Aug 2007 22:14:04 -0500
Message-ID: <fb5cls$geh$1@sea.gmane.org>
References: <46D622A5.2000205@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 75-132-102-43.dhcp.stls.mo.charter.com
User-Agent: Thunderbird 2.0.0.6 (X11/20070804)
In-Reply-To: <46D622A5.2000205@aladin.ro>
X-Enigmail-Version: 0.95.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu wrote:
> *This message was transferred with a trial version of CommuniGate(r) Pro*
> This might have been discussed a few years ago, but things have changed.
> I'm talking about patches like this one (I'm not the author):
> http://developer.osdl.org/dev/fumount/#kernel1
> 
> The current situation requires a way to forcibly unmount removable
> media. Consider the following (real) scenario. Someone has a box with
> hald + dbus + ivman to support "supermounting" the CDROM drive. He has
> to install a 2 CD application using Wine for example, but the setup
> application prevents normal unmounting of the first one. Then he goes on
> and pushes the button to eject the CD, lazy-unmounting the media. The
> kernel goes mad and all attempts to load the second CD fail (the kernel
> hasn't got rid of the first fs).
> 
> If there was anything like a real forced unmounting, things would have
> worked well, as on MS Windows itself.
> 
> As far as I can see, there is no other sane way to solve such problems.
> So, what's keeping such patches from making their way into the
> mainstream kernel? All (but maybe I haven't searched enough) arguments
> against such a feature that I've seen by now just say "it's not needed",
> "it's not worth it" and so on, and many of them refer to network mounts.
> 
> P.S.: I'm not saying lazy unmounting should be replaced. They both make
> sense, depending on the scenario.


There are patches in -mm for revokeat()/frevoke(), which can be used to
implement exactly that. If a device "vanishes" (CD is removed in the
middle of loading, USB pend rive yanked out the middle of I/O, NFS
server  thats gone MIA), A user-space program (maybe HAL) could iterate
over the open files and revoke() them, at which point the system can be
cleanly unmounted.

