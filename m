Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZBBFhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZBBFhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 00:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZBBFhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 00:37:43 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:61911 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZBBFhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 00:37:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:x-mailer;
        b=pLxOb0B4ZkyUsrxxffK7lj0uqoWoy86UcslgcdN16/nLDNF+Xv0UJnuHaebiesR6VG
         jf8AuUcR43EuWOW2Tx01FMk2IVeM3jMAyB9ly6Rrpz8TO+uHRTratlNfgSubt9HFRm+M
         RzIZkKjCy91yEAls3RpNQHcqLmUNoM+aPh8dM=
Message-Id: <F3E16090-CCDB-478F-BD0B-39E3E2E61A65@gmail.com>
From: Maoke Chen <fibrib@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: protocol lookup tables
Date: Mon, 2 Feb 2009 14:37:38 +0900
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

i'm a new comer in the Linux kernel programming. now we are doing  
something with socket system calls and related data structures. i'm a  
little confused with the concept "protocol lookup tables", because in  
the sock.h, there are several protocol lookup tables involved with the  
sock_common structure:

struct sock_common {
	unsigned short		skc_family;
	volatile unsigned char	skc_state;
	unsigned char		skc_reuse;
	int			skc_bound_dev_if;
	struct hlist_node	skc_node;
	struct hlist_node	skc_bind_node;
	atomic_t		skc_refcnt;
	unsigned int		skc_hash;
	struct proto		*skc_prot;
#ifdef CONFIG_NET_NS
	struct net		*skc_net;
#endif
};

the comment lines stated that the @skc_node stands for "main hash  
linkage for various protocol tables", while the @skc_bind_node for the  
"bind hash linkage for various protocol lookup tables", and so my  
question is: what is the difference between the "main hash" and the  
"bind hash"?

another related question is: what is the relationship between the sock  
data structure and the the bind bucket (tb)? how are they playing the  
role in the interactions between socket library and the protocol stack?

thanks and regards,
maoke

