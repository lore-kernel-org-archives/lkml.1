Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYENGrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYENGrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYENGrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:47:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbYENGrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:47:04 -0400
Date: Tue, 13 May 2008 23:46:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] common implementation of iterative div/mod
Message-Id: <20080513234627.30476c20.akpm@linux-foundation.org>
In-Reply-To: <48231959.4050406@goop.org>
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>
	<481DF3D8.3010108@shaw.ca>
	<a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>
	<48217674.8080903@goop.org>
	<48231959.4050406@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 16:16:41 +0100 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> We have a few instances of the open-coded iterative div/mod loop, used
> when we don't expcet the dividend to be much bigger than the divisor.
> Unfortunately modern gcc's have the tendency to strength "reduce" this
> into a full mod operation, which isn't necessarily any faster, and
> even if it were, doesn't exist if gcc implements it in libgcc.
> 
> The workaround is to put a dummy asm statement in the loop to prevent
> gcc from performing the transformation.
> 
> This patch creates a single implementation of this loop, and uses it
> to replace the open-coded versions I know about.

Believe it or not, this patch causes one of my test machines to fail to
find its disk.

good dmesg: http://userweb.kernel.org/~akpm/dmesg-t61p.txt
bad dmesg: http://userweb.kernel.org/~akpm/dmesg-t61p-dead.txt
config: http://userweb.kernel.org/~akpm/config-t61p.txt
