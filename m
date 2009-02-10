Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZBJBV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZBJBV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZBJBVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:21:49 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:56357 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZBJBVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:21:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=r2oDyU1QWPaV68bzR5PGkjBfRltyJzym4vsYwN1I59XlLi+eBaW8Ie1p3UVcedzgTw
         hZ3feWmCm7dEKBDpuKpXYks5quS73R+sacB4iBn7XjYNlW98jQVV8IYLijMlJ/+wIqMs
         ww061uk6Vw2g9x0KjN4fwEVUFHAIEmb6PVCGE=
MIME-Version: 1.0
Date: Mon, 9 Feb 2009 23:21:47 -0200
Message-ID: <cc0fa41f0902091721r62b735d1i5ea89c0663075f6e@mail.gmail.com>
Subject: cpufreq: last commit for 2.6.29 break cpufreq performance module
From: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After this commit 6707fbb56c8fd3121e334291d170934bcaca2e7f, if i
change the governor of cpufreq to performance, my processor still
shows 800MHz instead of 2268.

dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
ondemand

dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
800000

dub:/sys/devices/system/cpu/cpu0/cpufreq# echo performance > scaling_governor
dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
performance
dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
2267000

But, /proc/cpuinfo shows 800MHz:

model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
stepping        : 6
cpu MHz         : 800.000

And i cannot remove the ondemand module:

dub:/sys/devices/system/cpu/cpu0/cpufreq# rmmod cpufreq_ondemand
ERROR: Module cpufreq_ondemand is in use

I can confirm that it's not on 2268MHz because glxgears runs below the expected.

No errors on dmesg too.
