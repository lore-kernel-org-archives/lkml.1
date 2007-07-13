Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXGMMWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXGMMWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbXGMMWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:22:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:22250 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbXGMMWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rYjs2xmt7dUom01vzvi4VcvhOH59nC5BYp7/OQ0UFrGHxkFJGR4ByLYYZc8HlpACVC2tKV0P9hxmiYNTPmzhiKucbdaR1V+aLQkLuvdVVxtbMqnmUQrH8yS1RIU3AOOrFEyHYNXVuvwvVveI38/oS3uatwNS2iqvnOr0BOn2vWI=
Message-ID: <84144f020707130522l3a800b61i6b7c4d9084277cdf@mail.gmail.com>
Date: Fri, 13 Jul 2007 15:22:29 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Kalpak Shah" <kalpak@clusterfs.com>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <1184322648.4315.2.camel@garfield.linsyssoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1183275498.4010.135.camel@localhost.localdomain>
	 <20070710224011.e60b9864.akpm@linux-foundation.org>
	 <1184322648.4315.2.camel@garfield.linsyssoft.com>
X-Google-Sender-Auth: 3b1bff51d36c62d0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/07, Kalpak Shah <kalpak@clusterfs.com> wrote:
> > EXT4_DIR_LINK_MAX() is buggy: it evaluates its arg twice.
>
> #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)

[snip]

> Sorry, I didn't understand what is the problem with this macro?

The expression represented by 'dir' is evaluated twice (think dir++
here). It's safer to make it a static inline function.

                                       Pekka
