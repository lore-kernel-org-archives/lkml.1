Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYHZFIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYHZFIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 01:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYHZFID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 01:08:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:4557 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYHZFIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 01:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cRgUIDKrID0RZB7/Jns0i05E49KyBZk0s1Y2yicdhpoIbEmUXrLYo76dWT/JNpnYkH
         H61NmroXORtF2TLn/zzcxMJLwQdv13dQFk/j7ea5WghOoJvuPQe1QLOTAVNSdX/0Umof
         RURIkEbv76GmVfZzVlQpnIqGAKd1QBMY/gxn8=
Message-ID: <12c511ca0808252208n29043ab0lf9e56f94d5e4cb37@mail.gmail.com>
Date: Mon, 25 Aug 2008 22:08:00 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: PATCH] debug: add notifier chain debugging
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080825215555.2331f2cc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080815152938.4bc9d48c@infradead.org>
	 <12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com>
	 <20080825215555.2331f2cc@infradead.org>
X-Google-Sender-Auth: 7821e3f65a4e11ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This breaks on ia64 (and pa-risc I think) where function pointers
>> don't point directly at the code, they point to a {code,data}
>> structure which is itself located in data space, not text space.
>
> is there a way to go to the actual address? I'm sure this is a bit more
> common.... (like kallsyms!)

See dereference_function_descriptor() in lib/vsprintf.c (where it will
be clear that my memory was wrong and that PPC64 is the other
architecture that needs this).

Perhaps this needs to be moved to some place in asm-generic so
that it can be used by code like your sanity check?

-Tony
