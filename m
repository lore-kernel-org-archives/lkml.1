Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZABBgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZABBgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 20:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZABBfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 20:35:53 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43993 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZABBfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 20:35:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N53c/eTty9PSOYBiU24Jz3RFgQ4RMekgMP40ZrzrSGtggpvWCPN5N5coBkQoQDQec5
         mgmzvYpX1w6LXPRqjmI3YF9A5YIlC3TYfs6V6MXoVfGNvu0YhHCA+W1xRkSNX8vSWvW2
         FS4Kkz963TXG+XAutA/WEHKzJ3/Qgz7BpwGqc=
Message-ID: <7b9198260901011735k42e9298tb1c5dc0e15285eb1@mail.gmail.com>
Date: Fri, 2 Jan 2009 01:35:49 +0000
From: "Tom Spink" <tspink@gmail.com>
To: "Jesper Juhl" <jj@chaosbits.net>
Subject: Re: compile time warnings
Cc: "Ingo Brueckl" <ib@wupperonline.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0901012312450.11772@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495d3100@wupperonline.de>
	 <alpine.LNX.2.00.0901012312450.11772@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/1 Jesper Juhl <jj@chaosbits.net>:
> On Thu, 1 Jan 2009, Ingo Brueckl wrote:
[snip]

Hi,

> pgd_base is very much used...

It's probably something to do with:

# define permanent_kmaps_init(pgd_base)         do { } while (0)

Which is within the #else part of #if CONFIG_HIGHMEM.  So, if
CONFIG_HIGHMEM is not set, permanent_kmaps_init gets wiped out, and
therefore that warning will be issued.

Perhaps changing that to an empty inline would remove the warning?

-- 
Tom Spink
G. Gordon Liddy  - "Obviously crime pays, or there'd be no crime."
