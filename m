Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZEXMXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZEXMXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZEXMXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:23:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:43842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZEXMXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:23:23 -0400
Subject: Re: [PATCH-tip] x86: hwmon/k8temp.c Add support for AMD 10H and 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <4A182B61.5010503@assembler.cz>
References: <1242979484.8796.7.camel@localhost.localdomain>
	 <4A165F67.3020005@assembler.cz>
	 <1242981748.10642.3.camel@localhost.localdomain>
	 <1242984648.16532.3.camel@localhost.localdomain>
	 <4A182B61.5010503@assembler.cz>
Content-Type: text/plain
Date: Sun, 24 May 2009 17:49:44 +0530
Message-Id: <1243167584.3036.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 18:59 +0200, Rudolf Marek wrote:
> Hi,
> 
> Yes it works for most CPUs, but for unlucky users we might get complains from 
> them - and false alarms.
> 
> I'm talking about:
> 
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/41322.pdf
> 
> Errata #319
> 
> So far all CPUs have the issue.

>From manual :

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
319 Inaccurate Temperature Measurement
Description
The internal thermal sensor used for CurTmp (F3xA4[31:21]), hardware thermal control (HTC),
software thermal control (STC) thermal zone, and the sideband temperature sensor interface (SB-TSI)
may report inconsistent values.
Potential Effect on System
HTC, STC thermal zone, and SB-TSI do not provide reliable thermal protection. This does not affect
THERMTRIP or the use of the STC-active state through StcPstateLimit or StcPstateEn
(F3x68[30:28, 5]).
Suggested Workaround
None. Systems should be designed with conventional thermal control and throttling methods or
utilize PROCHOT_L functionality based on temperature measurements from an analog thermal diode
(THERMDA/THERMDC).
Systems should not rely on the HTC features, STC thermal zone features, or use SB-TSI.
Software should not modify HtcTmpLmt (F3x64[22:16]) or enable any of the STC thermal zone
features by setting StcApcTmpLoEn, StcApcTmpHiEn, StcSbcTmpLoEn, or StcSpcTmpHiEn
(F3x68[3:0]).

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

It seems that this problem is for some K10 processors.
And K11 is OK, right ?

I think our patch is safe enough and we will fix the problem for some
K10 processors or in the worst case we will remove support for that
particular cpu.

Ingo: do you mind to applying this patch on -tip and lets see its
feedback and fix the problem.

Thanks
--
JSR


