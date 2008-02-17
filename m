Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbYBQJpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbYBQJpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 04:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYBQJp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 04:45:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:17539 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYBQJpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 04:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BCBN30SUXXkQgBS0LqZpUWosWdIXk20Dtruga8iq4jW9GjXFn9K3tr1IyhcTF4BLQgfhu1XBiqtwJk1EdDMfQdNB7PkAwCWGQQ8an7ay7WCkJu4HPBjTRsXt7L2qD072ENp/oF/tYERbjnUuoz3N289fFdEkvaDM792wqhqZzzg=
Message-ID: <de8d50360802170145u4bd60f76x9662b66c63bdf41d@mail.gmail.com>
Date: Sun, 17 Feb 2008 01:45:23 -0800
From: "Andrew Pinski" <pinskia@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [Cbe-oss-dev] [PATCH 1/3] Fix Unlikely(x) == y
Cc: "Arjan van de Ven" <arjan@infradead.org>, linuxppc-dev@ozlabs.org,
       "Roel Kluin" <12o3l@tiscali.nl>, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080216175849.GA25636@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B70A61.9030306@tiscali.nl>
	 <20080216092552.325e5726@laptopd505.fenrus.org>
	 <20080216173315.GU8953@1wt.eu>
	 <20080216094226.1e8eede1@laptopd505.fenrus.org>
	 <20080216175849.GA25636@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 9:58 AM, Willy Tarreau <w@1wt.eu> wrote:
> Last but not least, gcc 4 tends to emit stupid checks, to the point that I
> have replaced unlikely(x) with (x) in my code when gcc >= 4 is detected. What
> I observe is that the following code :
>
>     if (unlikely(p == NULL)) ...
>
> often gets coded like this :
>
>     reg1 = (p == NULL)
>     if (reg1 != 0) ...
>
> ... which clobbers reg1 for nothing and performs a double test.

This really only can happen in GCC 4.0.x and 4.1.x and cannot happen
for 4.2 or 4.3 really because of the way __builtin_expect is handled
for those two.

-- Pinski
