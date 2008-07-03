Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYGCPiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYGCPiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGCPh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:37:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:38114 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYGCPhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Zn/FZpfcelFVNZH2isk0a1RulWfrqBOc7dN5UdmgdpIZpUvf0XHyYS6/LZhViru4Ff
         Ed1TZB+eEh/3qbLyHDtyLpEPOVM5tUENLoX1Z4ApBHGs+uwuAIBId3R8N20q3ehs8kzf
         DQStf9fRMErwh/duNtMRR8tb8N9a5QjDk/qEk=
Message-ID: <84144f020807030837k213e1880vf2d01bcf77e6886c@mail.gmail.com>
Date: Thu, 3 Jul 2008 18:37:52 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: slub: Do not use 192 byte sized cache if minimum alignment is 128 byte
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Yoichi Yuasa" <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <486CDEC2.5030803@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486CDEC2.5030803@linux-foundation.org>
X-Google-Sender-Auth: 3da82c6f83ddfb3c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 5:14 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> The 192 byte cache is not necessary if we have a basic alignment of 128
> byte. If it would be used then the 192 would be aligned to the next 128 byte
> boundary which would result in another 256 byte cache. Two 256 kmalloc caches
> cause sysfs to complain about a duplicate entry.
>
> MIPS needs 128 byte aligned kmalloc caches and spits out warnings on boot without
> this patch.
>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Looks good to me. Yoichi, did you have the chance to test this?
Christoph, are the warnings harmless or do we need to get this into
2.6.26?
