Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbYGEPy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbYGEPy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYGEPyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:54:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:27390 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYGEPyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dFpPU/h9IaalcjYHts7vcicpoj1HgBAP2O7MqSdaZleFInhzMOndilhNZu2SKaqetC
         R9Hl0vvvatB+j2Ou7xLTyQ3NnE6jTqk6L69CmYNxTsLGTIhm2eMA4qHlMgIn0oKip17b
         q77sZwWK71+dh1reyAONpdXNxh8KoAz66/5wQ=
Message-ID: <e9c3a7c20807050854o330279f7x3d64b1ec263f8800@mail.gmail.com>
Date: Sat, 5 Jul 2008 08:54:31 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "George Spelvin" <linux@horizon.com>
Subject: Re: 2.6.26-rc8 deadlock: RAID code?
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080704125551.24267.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080704125551.24267.qmail@science.horizon.com>
X-Google-Sender-Auth: e3b6625f66c13d37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 5:55 AM, George Spelvin <linux@horizon.com> wrote:
> I've seen this twice before, but had to get remote logging working to
> capture the initial error; once the root file system locks up there's
> an unending stream of these messages and even syslog can't actually
> log anything.
>
> (In fact, it locked up and stopped working after capturing this here.
> I'd have to get a null modem cable and serial console to capture more.)
>
> I can do it again, but it takes a few days.
>
> Hardware: single-core Athlon 64, ECC memory (scrubbing enabled),
> 6x SATA drives on 3x SiI3132 controllers.  Root file system (where I
> believe the problem is) is ext3 over RAID-10 over all drives.  Another,
> larger file system (that I can't see why the sensors daemon would touch)
> is ext3 over RAID5 over the same drives.
>
> Kernel is 2.6.26-rc8 + EDAC patches + linuxpps support.  This problem
> was not observed in 2.6.25 kernels (with the same patches).
>
> Any ideas?  For now, I'm going to turn on frame pointers and
> CONFIG_PROVE_LOCKING to get more information.
>

Are you running with CONFIG_NUMA=n?  If so, you may be seeing the
effects of kswapd not running. See the patch at:

     http://marc.info/?l=linux-mm&m=121510360428340&w=2

--
Dan
