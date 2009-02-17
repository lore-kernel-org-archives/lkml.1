Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZBQOi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZBQOi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZBQOiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:38:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:12732 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZBQOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kwFRxQ68VnEfxTzfAwJ8BeYULgLojjOB1BBIBlYBLmKyJjxLqbaHmaWS8ur9RJG8ij
         NqZtCyqffObIMjJN2xRoIy4dY4W2F85j1QJkPQ0rtJnbMJJvLj+XOP3/Li2VtDpl+/y0
         5WJPbURC5TqFau2qcnEQbPX5p0Zn5jLEyGOgM=
MIME-Version: 1.0
In-Reply-To: <76C7F485-EF75-4B83-B673-564E6243C7C6@kernel.crashing.org>
References: <D728AD1FA2543948B89DE29C5BF4CD0716AC2DDE@bjmail1.bj.datangmobile.com>
	 <76C7F485-EF75-4B83-B673-564E6243C7C6@kernel.crashing.org>
Date: Tue, 17 Feb 2009 22:38:18 +0800
X-Google-Sender-Auth: 55318fc37c4841a5
Message-ID: <2a27d3730902170638h43724c03k6b50843158842e1e@mail.gmail.com>
Subject: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)
From: Li Yang <leoli@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "<dayu@datangmobile.cn>" <dayu@datangmobile.cn>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:12 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Feb 17, 2009, at 6:44 AM, <dayu@datangmobile.cn> <dayu@datangmobile.cn>
> wrote:
>
>> From: Da Yu <dayu@datangmobile.cn>
>> Date: Tue, 17 Feb 2009 19:58:20 +0800
>> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)
>>
>> Signed-off-by: Da Yu <dayu@datangmobile.cn>
>> ---
>
> Please provide a bit more description as to why this fixes the issue.

The pending register is write 1 clear.  If there are more than one
external interrupts pending at the same time, acking the first
interrupt will also clear other interrupt pending bits.  That will
cause loss of interrupt.

- Leo
