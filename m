Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYLLHun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYLLHun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYLLHue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:50:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:19137 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYLLHud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:50:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CmxM7AIp884rXpMZ7a0yQ0zf5k1gIb7PfmX3f8vSLv5N7+N0ex8wUkHodieiEJpzHe
         rhXwR1cZvrexzNKkBXlwp+zaXafKna1h9K60P7/mv+KYd6xW002NLmy5Y3s9TARgmYZK
         5ze4QMr5LYIUmhaZZcDvRREP2ABbhtf/1BWy0=
Message-ID: <84144f020812112350m6c5f4ccbyded45b6ca50f699d@mail.gmail.com>
Date: Fri, 12 Dec 2008 09:50:31 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH mmotm 3/5] nilfs2: avoid double error caused by nilfs_transaction_end
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1229059021-9538-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1229059021-9538-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1229059021-9538-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Google-Sender-Auth: f1fc8fb9616dc970
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryusuke,

On Fri, Dec 12, 2008 at 7:16 AM, Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:
> Pekka Enberg pointed out that double error handlings found after
> nilfs_transaction_end() can be avoided by separating abort operation:
>
>  OK, I don't understand this. The only way nilfs_transaction_end() can
>  fail is if we have NILFS_TI_SYNC set and we fail to construct the
>  segment. But why do we want to construct a segment if we don't commit?
>
>  I guess what I'm asking is why don't we have a separate
>  nilfs_transaction_abort() function that can't fail for the erroneous
>  case to avoid this double error value tracking thing?
>
> This does the separation and renames nilfs_transaction_end() to
> nilfs_transaction_commit() for clarification.
>
> Since, some calls of these functions were used just for exclusion
> control against the segment constructor, they are replaced with
> semaphore operations.
>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Nice cleanup!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
