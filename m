Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZATN5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZATN5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZATN5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:57:22 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:50613 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbZATN5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:57:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZOp7d6UB3GzacW5pCaM5ocVEFj112N1A7Q1VgNeSUY1JQI42QqVrPaJnxomyPYXtcI
         T7o+gZEVzWmAITh06mTXZKWQaRNqdTnfHtxH7nVYdtYOKWRQ06/4+uHHkDSYDfhhQhxM
         FxaOwPlOthBB9Qcy3N2vWEXCsUeBV57QZ/98Y=
Message-ID: <4975D88B.7020906@gmail.com>
Date: Tue, 20 Jan 2009 14:58:35 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org> <20090120124515.GA31838@infradead.org>
In-Reply-To: <20090120124515.GA31838@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig pisze:
> On Tue, Jan 20, 2009 at 07:13:35AM -0500, Christoph Hellwig wrote:
>> On Tue, Jan 20, 2009 at 06:49:06AM -0500, Christoph Hellwig wrote:
>>>>> Just curious:  do you have CONFIG_LBD set?
>>>>>
>>>> Hi Christoph,
>>>>
>>>> the answer is:
>>>> $ grep LBD .config
>>>> # CONFIG_LBD is not set
>>> Ok, let me reproduce it without that set..
>> Ok, on 32-bit x86 without CONFIG_LBD I can reliably reproduce the issue
>> with the following script:
> 
> Bisected down to:
> 
> commit 91cca5df9bc85efdabfa645f51d54259ed09f4bf
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Thu Oct 30 16:58:01 2008 +1100
> 
>     [XFS] implement generic xfs_btree_delete/delrec
> 
>     Make the btree delete code generic. Based on a patch from David Chinner
>     with lots of changes to follow the original btree implementations more
>     closely. While this loses some of the generic helper routines for
>     inserting/moving/removing records it also solves some of the one off bugs
>     in the original code and makes it easier to verify.
> 

Good job! Is there some ,,quick'' fix?

-Jacek
