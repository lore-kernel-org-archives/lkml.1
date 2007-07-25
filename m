Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbXGYWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbXGYWQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXGYWQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:16:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:12988 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbXGYWQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sU+2+ccRKj07o+sPHKuTm6SnTnvXkKZ06Hb8/ISZPCps1zfmjdJWNEnV0GWN2u4iRoycmF71xrGzMUM9IjawqwIJbfjeRRhxLXni+ktm8/8HJDKx/lNszJDbo6yGcV2Ql7tXYtmg1hb8YUFvqlss4s7IzhO1lZ+E2HibPmRknZM=
Message-ID: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com>
Date: Wed, 25 Jul 2007 17:16:01 -0500
From: Satya <satyakiran@gmail.com>
To: linuxppc-dev@ozlabs.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: pte_offset_map for ppc assumes HIGHPTE
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
The implementation of pte_offset_map() for ppc assumes that PTEs are
kept in highmem (CONFIG_HIGHPTE). There is only one implmentation of
pte_offset_map() as follows (include/asm-ppc/pgtable.h):

#define pte_offset_map(dir, addr)               \
         ((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))

Shouldn't this be made conditional according to CONFIG_HIGHPTE is
defined or not (as implemented in include/asm-i386/pgtable.h) ?

the same goes for pte_offset_map_nested and the corresponding unmap functions.

thanks,
Satya Popuri
