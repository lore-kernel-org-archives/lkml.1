Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZKLNbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZKLNbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZKLNba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:31:30 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:33367 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZKLNb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:31:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RiBG9A09VZWhutZ2OjtPBIwOY8jjyZxbUlHXVYC3YZTOJRXqHA+8kZGVRMu5m9NT5L
         /mcHg8MYsZyBfDRcCkqFCxupBArGDlg8ArFB+Vq+UY/RCDSmySgcin8UWtcPPE3fiXDK
         J/nYjrVjoyebWj7UI65OXeZSr/F1NWW2a++mQ=
MIME-Version: 1.0
In-Reply-To: <20091111134730.a0da9e38.akpm@linux-foundation.org>
References: <4AFB2C0B.50605@gmail.com>
	 <20091111134730.a0da9e38.akpm@linux-foundation.org>
Date: Thu, 12 Nov 2009 13:31:34 +0000
X-Google-Sender-Auth: 0ffd994d68f2072d
Message-ID: <25d66d860911120531u6a9cd40dmf3056fd99bd97f4e@mail.gmail.com>
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roel Kluin <roel.kluin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       ingo <mingo@elte.hu>, rostedt@goodmis.org, apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>       s = kmalloc(sizeof(*s), GFP_KERNEL);
>>       if (!s)
>> -             return ENOMEM;
>> +             return -ENOMEM;
>>
>>       trace_seq_init(s);
>>
>
> lol, there we go again.
>
> Andy, can we have a checkpatch rule please?

Thats a tricky one.  Not only do we not really have a sensible way to
know if ENOMEM is an errno, we also find a bunch of places that we
appear to use positive errno's as return values where we would falsly
complain about.  Its particularly common in scsi and filesystems.
Admittedly the vast majority are return -EXXX form, so we could add
this as a non-default check perhaps.

Thoughts?

-apw
