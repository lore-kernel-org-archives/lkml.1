Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbXIZLN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbXIZLN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXIZLNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:13:49 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34363 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbXIZLNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:13:48 -0400
Message-ID: <46FA3EE8.4080707@davidnewall.com>
Date: Wed, 26 Sep 2007 20:43:44 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com> <20070926104500.GA4354@dspnet.fr.eu.org>
In-Reply-To: <20070926104500.GA4354@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> chroot does not allow you to walk out if you're in.

You're mistaken.  Or more properly, further use of chroot lets you walk 
out.  This really has been said before, and before, and before.

    chroot("subtree");   // enter chroot
    chdir("/");    // now at subtree
    chroot("/tmp");   // now outside of chroot


BSD redefined chroot so that the working directory is set to the new 
root on subsequent uses of chroot; that's how they solved the bug.
