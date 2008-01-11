Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbYAKW6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbYAKW6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbYAKW5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:57:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:51028 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761854AbYAKW5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NEwMQknEv0rTyvVVx0IpmKVoiN68DhEhjT14Qn6/WYKvTzP+2aLN1xj2uieA3j2eKKaU+eOnr3dtg6ns5ccDYk9mfatYaRfo2P4ogBX5VvgJajDBAWuR5m15v3+K8TSo+uMwEEheLvr9iVQHcaMtm5sbD7mKi1vZ+33p98SNLQc=
Message-ID: <9f4f8abe0801111457t7535069ar1f98cc37d5cf8d40@mail.gmail.com>
Date: Fri, 11 Jan 2008 14:57:47 -0800
From: "Vineet Gupta" <vineetg76@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Usage semantics of atomic_set ( )
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to implement atomic ops for a CPU which has no inherent
support for Read-Modify-Write Ops. Instead of using a global spin lock
which protects all the atomic APIs, I want to use a spin lock per
instance of atomic_t. This works well when atomic_t is unitary and
statically initialized using ATOMIC_INIT (where I can reset the
spinlock_t as well). However if atomic_t var is embedded within a
bigger struct which is allocated dynamically how to I init the
embedded spin lock. atomic_set ( ) is the closest choice, however I
don't think it's current usage in kernel code qualifies it to be
"initializer only".

Doesn't that defeat the intended usage of atomic_t as a opaque type
which can be "effectively" used to hide other architecture specific
stuff.

Thanks,
Vineet
