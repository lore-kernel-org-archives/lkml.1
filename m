Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbYGBEpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbYGBEpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYGBEpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:45:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46662
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbYGBEpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:45:06 -0400
Date: Tue, 01 Jul 2008 21:45:07 -0700 (PDT)
Message-Id: <20080701.214507.261426026.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: helge.hafting@aitel.hist.no, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [10 PATCHES] inline functions to avoid stack overflow
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0807020032510.19403@engineering.redhat.com>
References: <Pine.LNX.4.64.0806250843460.20379@engineering.redhat.com>
	<20080625.150931.182895076.davem@davemloft.net>
	<Pine.LNX.4.64.0807020032510.19403@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 2 Jul 2008 00:39:35 -0400 (EDT)

> The ABI is very vague about it. The V9 ABI just displays that 6-word space 
> in a figure bug doesn't say anything about it's usage. The V8 ABI just 
> says that "the function may write incoming arguments there". If it may 
> write anything other, it is unknown --- probably yes, but it is not said 
> in the document.
> 
> The document nicely specifies who owns which registers, but doesn't say 
> that about the stack space :-(

Actually, I know for a fact that you have to have those slots there.

A long time ago in the sparc64 kernel, in the trap entry code, I tried
only giving 128 bytes of stack frame as the trap entry called into C
code.  And it did not work, I had to put the 6 slots there.
