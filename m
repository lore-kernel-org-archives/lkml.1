Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZDSKU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZDSKU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 06:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZDSKUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 06:20:19 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:46764 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbZDSKUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 06:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wSQNM3aXgjtFkNUEN8ZytSYd0J+jHvVJW8UL5MKkkzkS+xIPbjI3tF6nqyGlzj6k6g
         7P+Yh+Vy8UL4zV3vFIb4RfVc+ndYSOufoXSoNMJdghiTLyAdxF/k78ALEdfIt8wPCb1E
         YVAv2cPwLtL6NyOjUgD5xbxPaxCwoWWcmxy8E=
Message-ID: <49EAFACD.6040302@gmail.com>
Date: Sun, 19 Apr 2009 12:19:57 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, rakib.mullick@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix false positive section mismatch warnings
 in the apic code
References: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com> <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org> <49EAF31C.8020108@gmail.com> <20090419095759.GA4808@elte.hu>
In-Reply-To: <20090419095759.GA4808@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
>> tip-bot for Rakib Mullick pisze:
>>> Commit-ID:  aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
>>> Gitweb:     http://git.kernel.org/tip/aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
>>> Author:     Rakib Mullick <rakib.mullick@gmail.com>
>>> AuthorDate: Sun, 19 Apr 2009 08:41:17 +0600
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Sun, 19 Apr 2009 11:28:18 +0200
>>>
>>> x86: Fix false positive section mismatch warnings in the apic code
>>>
>>> find_unisys_acpi_oem_table() and unmap_unisys_acpi_oem_table() 
>>> are non init functions, but these functions calls some init 
>>> functions. But we need these functions as non-init functions.
>> Why? This warning seems to be valid.
> 
> It's put into struct apic::acpi_madt_oem_check - which is a non-init 
> structure. That particular field is only used from init context - 
> but other fields are used all the time.

Can we have a rule that "every __ref usage should have a comment explaining
why __ref is safe in this place"? 

Marcin

