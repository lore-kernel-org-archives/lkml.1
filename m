Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbYG3MS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbYG3MS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbYG3MSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:18:20 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:18928 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbYG3MST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=LMMMne3K5Dz7KvbHUKc0AsjA0sSvDbkZV+fudhULs9kL6qcsHuXJaXiimx3lKm18S+
         JzhJ86qSMyBafI7SsQLCyU8/FwjsgWB3/8GtfmbtixoO7hgr4FB5JdtBNv3k9xbPDTGn
         Hg6ZdggjdDc05ws3+pQet20dVjezcUcHr6ba8=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: wrong register was used in align macro
References: <m3sktr6249.fsf@gravicappa.englab.brq.redhat.com>
Date: Wed, 30 Jul 2008 14:17:54 +0200
In-Reply-To: <m3sktr6249.fsf@gravicappa.englab.brq.redhat.com> (Vitaly
	Mayatskikh's message of "Wed, 30 Jul 2008 13:30:14 +0200")
Message-ID: <m38wvj5zwt.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:

Register ecx was also wrongly loaded with value in r8d in
copy_user_nocache routine.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 40e0e30..cb0c112 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -108,7 +108,6 @@ ENTRY(__copy_user_nocache)
 	jmp 60f
 50:	movl %ecx,%edx
 60:	sfence
-	movl %r8d,%ecx
 	jmp copy_user_handle_tail
 	.previous
 

-- 
wbr, Vitaly
