Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbXHWAFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbXHWAFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXHWAFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:05:19 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:32981 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbXHWAFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:05:16 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "lode leroy" <lode_leroy@hotmail.com>
Subject: Re: [PATCH] memchr (trivial) optimization
Date: Thu, 23 Aug 2007 02:13:20 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl>
In-Reply-To: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708230213.21332.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2007, lode leroy wrote:
> While profiling something completely unrelated, I noticed
> that on the workloads I used memchr for, I saw a 30%-40% improvement
> in performance, with the following trivial changes...
> (basically, it saves 3 operations for each call)

Yes, but then you could be a bit more explicit to the compiler
on what you are doing here:
 
void *memchr(const void *s, int c, size_t n)
{
	const unsigned char *p = s;

	for (; n != 0; n--, p++) {
               if ((unsigned char)c == *p) {
                       return (void *)p;
	}
	return NULL;
}

Now the compiler should see the loop more clearly.


Best Regards

Ingo Oeser
