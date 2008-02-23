Return-Path: <linux-kernel-owner+w=401wt.eu-S934983AbYBWLdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983AbYBWLdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYBWLcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:32:53 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:23453 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYBWLcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q9uS2RU8rvwDL1tSt/+77HN2ZQnBPDzg3EV0bIVpEbO9osocQtcqhv4hDCyPiXcuKiTAZuNRPk7HsoSRJSMQG/MpKbgjZgqw+zaOcHFSeqOF9f5C/zdmuWyBS0CVhqXac7r3ct39iwTATsi30f/8s2Zuw7CmoMigQ0yNC0dwnh8=
Message-ID: <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
Date: Sat, 23 Feb 2008 14:32:50 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Michael Buesch" <mb@bu3sch.de>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080223112436.GA31304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de>
	 <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de>
	 <20080223110751.GN23833@elte.hu>
	 <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
	 <20080223112436.GA31304@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 2:24 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>  > Agreed. Alexey, did you identify a specific git commit that caused the
>  > regression? Can we just revert that from 2.6.24? Michael, even if
>  > _you're_ planning to remove bcm43xx we must not let it regress until
>  > it's gone.
>
>  btw., if the best answer is: "do not enable b43 and bcm43xx at once in
>  the .config because we messed up the dependencies and fixing it in
>  2.6.24-stable is unfortunately too risky", then that's a perfectly fine
>  answer for -stable. Then the fix would be to exclude each other in the
>  Kconfig space (which is not risky). But just ignoring bugreports and
>  NAK-ing a fix is not a valid answer.
>

The problem is not with enabling both b43 and bcm43xx (will, whis won't work
anyway, and there is no chance fixing it). The problem is with enabling the
bcm43xx wifi driver and the b44 Ethernet driver. The ethernet driver then
wrongly autosolects some config options that prevent the bcm43xx
driver from loading, so I'm left with either no wifi or no ethenet.


>         Ingo
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
