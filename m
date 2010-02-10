Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0BJOD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 09:03:27 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33917 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0BJODZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 09:03:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ReQeTuvcDEYIVMmtxP3p2sNm9ObzcADihdzYgQVN9ApTv/vpJRkRYrJO/uMDJ9jb8g
         UwW7nfCjv6S6pH4Y5RZRdqqII2e1b29/KAz4geVS+zOpsws1BYyJnfZzP03+UO+tSfG+
         pJLqikvzeCTSOWBu/09fWZJJMdo5UNT75LNQw=
Message-ID: <4B72BE49.70803@gmail.com>
Date: Wed, 10 Feb 2010 15:10:17 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: m68knommu: duplicate _ramvec[vba+CPMVEC_RISCTIMER] assignment in
 init_IRQ()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at arch/m68knommu/platform/68360/ints.c I noted two things that
stood out:

1) on line 110:

_ramvec[vba+CPMVEC_RISCTIMER]   = inthandler;  /* reserved */

and 114:

_ramvec[vba+CPMVEC_RISCTIMER]   = inthandler;  /* timer table */

The same definitions are used, and in the first case the comment and
definition do not correspond.

2) while all other definitions are used like this:

_ramvec[vba+CPMVEC_DEF2]   = inthandler;
...
_ramvec[vba+CPMVEC_DEF1]   = inthandler;

This is not true for CPMVEC_RESERVED:

_ramvec[vba+CPMVEC_RESERVED1]   = inthandler;   /* reserved */
...
_ramvec[vba+CPMVEC_RESERVED2]   = inthandler;  /* reserved */

Is this a bug?

Roel
