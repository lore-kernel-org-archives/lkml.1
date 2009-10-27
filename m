Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZJ0Aok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZJ0Aok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbZJ0Aoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:44:39 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:61311 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbZJ0Aoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PQVhRu67EnaUWnm4hhfj9g9uIaqQ0qHjH+OxEsvqpHPk6PG1Qcbopem6Pi9wPsJ8Ma
         tS3/l+jV+zPg7carVAo1JAJwQ2cXwo2x9AFuLfX23x4x5jAz1bHZEll4jBckSozzTCH0
         LppvyNZNDiA+t06tv3MMf/Rd462NWYTIEUXO4=
Message-ID: <4AE64279.4080902@gmail.com>
Date: Mon, 26 Oct 2009 18:44:41 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Bradbury <robert.bradbury@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Broken ondemand scheduler in Linux 2.6.30+ on Pentium IVs
References: <deaa866a0910251546m7ea001bcm252c41e65927a424@mail.gmail.com>
In-Reply-To: <deaa866a0910251546m7ea001bcm252c41e65927a424@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2009 04:46 PM, Robert Bradbury wrote:
> Somewhere in the Linux 2.6.30+ patches was a change to
> "arch/x86/kernel/cpu/cpufreq/
> p4-clockmod.c" which changed (around line 253) such that
>    policy->cpuinfo.transition_latency = 1000000; /* assumed */
> became
>    policy->cpuinfo.transition_latency = 10000001;
>
> This prevents the ondemand scheduler from being adopted and working
> correctly (on a system with the Gnome CPU Frequency Monitor).  The
> reports I have received regarding *why* this change was made are
> cryptic at best.

p4-clockmod is NOT true CPU frequency scaling, it just forces the CPU to 
idle on a periodic duty cycle and has no effect on CPU frequency. The 
clock modulation feature is basically just engaging the same mechanism 
the CPU uses to reduce heat output when it gets too hot, and which is 
not meant as a power saving mechanism. When engaged, it does reduce heat 
output and power usage, but not as much as it reduces system 
performance, and means the system will simply take longer to return to 
idle. In short, using p4-clockmod can only increase power usage in any 
real workload.

If your system and CPU actually support CPU frequency scaling then 
p4-clockmod isn't the driver that should be being used, acpi-cpufreq is 
the one on most systems.
