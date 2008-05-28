Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYE1TvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYE1TvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYE1TvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:51:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:23133 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYE1TvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kLf6+NwCr93527RWKz734JLDbDSkYQ/GCd5i08/YjVhHZ5mD0ZaHyDdSfNnnKLXLxD3I91zgnssrL9BbPjaxFaIgVSaB2AUO4E5Ku7/QQH/zP5a6+reqL984eXMd/qPhxYh95VBnxELOo2J4HJPCYDdpMTHbr/lscnM5kG+1VVQ=
Message-ID: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
Date: Wed, 28 May 2008 14:51:02 -0500
From: "Steve French" <smfrench@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: optimizing out inline functions
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In trying to remove some macros, I ran across another kernel style
question.  I see two ways that people try to let the compiler optimize
out unused code and would like to know which is preferred.  The first
example uses an empty inline function and trusts the compiler will
optimize it out.

#ifdef CONFIG_DEBUG_SOMETHING
static inline void some_debug_function(var1)
{
    something = var1;
    printk(some debug text);
}
#else
static inline void some_debug_function(var1)
{
   /* empty function */
}
#endif


alternatively I have seen places where people put a #define of do while 0, e.g.



#ifdef CONFIG_DEBUG_SOMETHING
static inline void some_debug_function(var1)
{
    something = var1;
    printk(some debug text);
}
#else
#define some_debug_function(var) do {} while (0)
#endif


Is one or the other style (with or without #define of empty function)
preferred?  Does the compiler optimize both #else clauses out
properly?  sparse and checkpatch seem to take either

-- 
Thanks,

Steve
