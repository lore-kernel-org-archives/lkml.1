Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbZGHGro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbZGHGro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbZGHGra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:47:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50225 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671AbZGHGr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xC1T7KLqUNO73jxjcI3OhW9YHqAlVMBsAES1acoDCneo9FRzS4GV9fYDU71kY0bDd2
         ewWW1bOup6/Ly5EvduvSiB6WZP5WnmpuxZGPcyjBB0GUD6t2FhpDEEhQ5E+Prmh8z695
         LjY50UZwqDDKxHgSyHwPPPNiPg2ActFsPy4Wo=
Message-ID: <4A5440FE.6000708@gmail.com>
Date: Wed, 08 Jul 2009 08:47:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Matthias Pfaller <leo@marco.de>, linux-kernel@vger.kernel.org
Subject: Re: Bug in dmi_get_year (causing apic not getting enabled)
References: <4A53728B.9020703@marco.de> <m1iqi3wxai.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqi3wxai.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2009 07:36 AM, Eric W. Biederman wrote:
> Matthias Pfaller <leo@marco.de> writes:
> 
>> Hi,
>>
>> dmi_get_year extracts the year with:
>>
>> 	simple_strtoul(s, NULL, 0);
>>
>> for biosdates in 2008 and 2009 this will return 0 because 8 and 9 are no valid
>> octal digits. This will e.g. result in the apic not getting enabled.
>> Changing this to
>>
>> 	simple_strtoul(s, NULL, 10);
>>
>> should fix the problem.
> 
> Only if there is a leading 0....

Yes, 4-digit year is required as of smbios 2.3 (1998). There are broken
BIOSes out there though. So there is no need to guess base if we know
it. I sent a fix for this yesterday. Any objections?
