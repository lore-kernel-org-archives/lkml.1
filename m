Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYCKS7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYCKS7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYCKS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:59:08 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2893 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYCKS7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:59:07 -0400
Subject: Re: [PATCH 1/5] lib: introduce call_once()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080311103517.5b6dc23f.akpm@linux-foundation.org>
References: <20080310145704.GA6396@APFDCB5C>
	 <20080310204853.3108d21c.akpm@linux-foundation.org>
	 <200803111510.52761.nickpiggin@yahoo.com.au>
	 <20080310212108.5882011e.akpm@linux-foundation.org>
	 <961aa3350803110527g4d6654ew34847807e46da315@mail.gmail.com>
	 <20080311103517.5b6dc23f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 11:56:55 -0700
Message-Id: <1205261815.3165.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 10:35 -0700, Andrew Morton wrote:
> #define ONCE()                                              \
>     ({                                              \
>             static long flag;                       \
>                                                     \
>             return !test_and_set_bit(0, flag);      \
>     })

test_and_set_bit takes an address

Perhaps:

#define DO_ONCE(x) \
	({ static long flag; if (test_and_set_bit(0, &flag)) x; 1; })

DO_ONCE(foo);

