Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZBKKRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZBKKRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZBKKRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:17:14 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:63908 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZBKKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=aSrEblrUQFC1gm/WG+yYmciev/4CaWJZetWSblU81T/O/QEgOXUOf4M/dZKMbeN9dK
         OVs+18g5DCchZ84n96aBY5I8ZL4fLP9LM+7BwrhhhZ/FytPhXXoUJex4tpkjMSw+yIT6
         AvLlLoi8XtAiKslVpDlbhGCbOI1YaOTdYqxcY=
Message-ID: <4992A59F.5090502@gmail.com>
Date: Wed, 11 Feb 2009 11:17:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>
Subject: Re: ACPI: S4 disappeared [mmotm 2009-02-10-16-35]
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <499291A3.9070501@gmail.com>
In-Reply-To: <499291A3.9070501@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2009 09:51 AM, Jiri Slaby wrote:
> On 02/11/2009 01:36 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded
> 
> Hi,
> 
> I've found out, that S4 disappeared in this release, in comparison to mmotm
> based on 2.6.29-rc2:
> -ACPI: (supports S0 S1 S3 S4 S5)
> +ACPI: (supports S0 S1 S3 S5)
> 
> Any ideas what could have caused this?

I think this one
ARCH_HIBERNATION_POSSIBLE=n
because
SMP=y
since
 config ARCH_HIBERNATION_POSSIBLE
        def_bool y
-       depends on !SMP || !X86_VOYAGER
+       depends on !SMP

The condition was wrong, ok, anyway it worked. Would
depends on !SMP || EXPERIMENTAL
make sense? The smp is handled in disable_nonboot_cpus manner, right?
