Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0BRXiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:38:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:10996 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0BRXiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:38:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Yhub/7OiQFI9PS5ntvINiMIAsrY1jTtjU63V06f5NWhy2hesUopM2jP0KeNK6rDvOa
         lJWX/qRxLncxBoyUB5BsKcpCBHs2ziHG5lt6575KxtJEXtcRrax0YwensfxAUysH3sJf
         RVUqhloROC8L93bJXm7HHtGmEhZmfXZ7ZW2AQ=
MIME-Version: 1.0
In-Reply-To: <4B7D97A6.4060900@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-3-git-send-email-luca@luca-barbieri.com>
	 <4B7D97A6.4060900@zytor.com>
Date: Fri, 19 Feb 2010 00:38:48 +0100
X-Google-Sender-Auth: 1f9b862e9be1d699
Message-ID: <ff13bc9a1002181538q7ccc1381x32a2f25bfb6d56cc@mail.gmail.com>
Subject: Re: [PATCH 02/10] x86: add support for relative CALL and JMP in 
	alternatives
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The existing instruction parser is only present if KPROBES is configured
> in... this patch would make it obligatory.  Your patch doesn't reflect
> that.  Furthermore, it is ~16K of code and data which probably will make
> embedded people unhappy... although perhaps isn't out of line.
Didn't notice that.

> A good question, though, is if we actually need support for JMP or CALL
> as anything but the first instruction (usually the *only* instruction),
> which would make it a lot easier...

Probably not.
I think an even better option is to create a CALL if replacementlen is 0xff.
This would save some space for each callsite and make it clear we only
support this usage.
