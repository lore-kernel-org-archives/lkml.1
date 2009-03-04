Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZCDPb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZCDPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZCDPbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:31:20 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:46042 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZCDPbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:31:19 -0500
Message-ID: <49AE9EA4.2080500@krogh.cc>
Date: Wed, 04 Mar 2009 16:30:44 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc>	 <1235685269.6811.11.camel@localhost.localdomain>	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>	 <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>	 <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc> <1236118969.6068.87.camel@localhost>
In-Reply-To: <1236118969.6068.87.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> I guess something to test my idea above (that the drift is bad enough
> that NTPd isn't making slew adjustments via adjtimex offset) is to
> remove NTPd from the init.d startup.
> 
> Then after rebooting (into 2.6.29), run the attached python script for
> 10 minutes or so to get an idea of the ppm drift. Then repeat with
> 2.6.26.
> 
> To run: 
> ./drift-test.py <ntp server>
> 
> It will give some wild ppm numbers, but after a few minutes it should
> settle down to the "natural drift" of the system.

Ok. I removed ntpd from the system... heres is from "non-working 
2.6.28.7 kernel".
04 Mar 14:59:16 	offset: -0.139829 	drift: -656.0 ppm
04 Mar 15:00:16 	offset: -0.175233 	drift: -591.147540984 ppm
04 Mar 15:01:16 	offset: -0.210637 	drift: -590.611570248 ppm
04 Mar 15:02:16 	offset: -0.246033 	drift: -590.386740331 ppm
04 Mar 15:03:17 	offset: -0.28144 	drift: -587.880165289 ppm
04 Mar 15:04:17 	offset: -0.31684 	drift: -588.301324503 ppm
04 Mar 15:05:17 	offset: -0.352247 	drift: -588.602209945 ppm
04 Mar 15:06:17 	offset: -0.387649 	drift: -588.805687204 ppm
04 Mar 15:07:17 	offset: -0.423046 	drift: -588.94813278 ppm
04 Mar 15:08:17 	offset: -0.458451 	drift: -589.073800738 ppm
04 Mar 15:09:18 	offset: -0.493856 	drift: -588.1973466 ppm
04 Mar 15:10:18 	offset: -0.529265 	drift: -588.374057315 ppm
04 Mar 15:11:18 	offset: -0.564661 	drift: -588.503457815 ppm
04 Mar 15:12:18 	offset: -0.600063 	drift: -588.620689655 ppm
04 Mar 15:13:18 	offset: -0.635458 	drift: -588.712930012 ppm
04 Mar 15:14:18 	offset: -0.040699 	drift: 109.052048726 ppm
04 Mar 15:15:18 	offset: -0.076098 	drift: 65.4984423676 ppm
04 Mar 15:16:18 	offset: -0.111495 	drift: 27.0557184751 ppm
04 Mar 15:17:18 	offset: -0.146885 	drift: -7.12096029548 ppm
04 Mar 15:18:19 	offset: -0.182285 	drift: -37.6853146853 ppm
04 Mar 15:19:19 	offset: -0.217688 	drift: -65.2117940199 ppm
04 Mar 15:20:19 	offset: -0.253085 	drift: -90.1202531646 ppm
04 Mar 15:21:19 	offset: -0.288479 	drift: -112.768882175 ppm
04 Mar 15:22:19 	offset: -0.323866 	drift: -133.448699422 ppm
04 Mar 15:23:19 	offset: -0.359259 	drift: -152.414127424 ppm
04 Mar 15:24:20 	offset: -0.394648 	drift: -169.750830565 ppm
04 Mar 15:25:20 	offset: -0.430047 	drift: -185.861980831 ppm
04 Mar 15:26:20 	offset: -0.46544 	drift: -200.779692308 ppm
04 Mar 15:27:20 	offset: -0.500835 	drift: -214.63620178 ppm
04 Mar 15:28:20 	offset: -0.536221 	drift: -227.534670487 ppm
04 Mar 15:29:20 	offset: -0.571605 	drift: -239.574515235 ppm
04 Mar 15:30:21 	offset: -0.606992 	drift: -250.706859593 ppm
04 Mar 15:31:21 	offset: -0.64241 	drift: -261.286085151 ppm
04 Mar 15:32:21 	offset: -0.677792 	drift: -271.20795569 ppm
04 Mar 15:33:21 	offset: -0.713187 	drift: -280.554252199 ppm
04 Mar 15:34:21 	offset: -0.040744 	drift: 46.7374169041 ppm
04 Mar 15:35:21 	offset: -0.076145 	drift: 29.0987996307 ppm
04 Mar 15:36:21 	offset: -0.111551 	drift: 12.4088050314 ppm
04 Mar 15:37:21 	offset: -0.146952 	drift: -3.40288713911 ppm

And from working 2.6.27.19 kernel.

jk@quad12:~$ python drift-test.py 10.192.96.19
04 Mar 16:17:23         offset: -0.006929       drift: -62.0 ppm
04 Mar 16:18:24         offset: -0.010252       drift: -54.5967741935 ppm
04 Mar 16:19:24         offset: -0.013574       drift: -54.9754098361 ppm
04 Mar 16:20:24         offset: -0.016897       drift: -55.1098901099 ppm
04 Mar 16:21:24         offset: -0.020233       drift: -55.2314049587 ppm
04 Mar 16:22:24         offset: -0.023566       drift: -55.2947019868 ppm
04 Mar 16:23:24         offset: -0.026895       drift: -55.3259668508 ppm
04 Mar 16:24:24         offset: -0.030217       drift: -55.3317535545 ppm
04 Mar 16:25:24         offset: -0.033539       drift: -55.3360995851 ppm
04 Mar 16:26:24         offset: -0.036865       drift: -55.3468634686 ppm
04 Mar 16:27:25         offset: -0.038266       drift: -52.0713101161 ppm
04 Mar 16:28:25         offset: -0.039747       drift: -49.592760181 ppm
04 Mar 16:29:25         offset: -0.041331       drift: -47.6680497925 ppm


-- 
Jesper


