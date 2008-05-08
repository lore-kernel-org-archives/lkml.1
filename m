Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbYEHU6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbYEHU6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYEHU6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:58:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33132 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbYEHU6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:58:19 -0400
Date: Thu, 8 May 2008 21:58:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/6] ide: remove IDE_TFLAG_NO_SELECT_MASK taskfile flag
Message-ID: <20080508205802.GA5722@flint.arm.linux.org.uk>
References: <200805071943.24296.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805071943.24296.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 07:43:24PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Always call SELECT_MASK(..., 0) in ide_tf_load() (needs to be done
> to match ide_set_irq(..., 1)) and then remove IDE_TFLAG_NO_SELECT_MASK
> taskfile flag.
> 
> This change should only affect hpt366 and icside host drivers since
> ->maskproc(..., 0) for sgiioc4 is equivalent to ide_set_irq(..., 1).

Provided the two channels on icside are serialised (so IDE doesn't
try to enable IRQs on both channels at the same time) it shouldn't
be a problem.

However, since I don't use this driver anymore (using the PATA version
instead) I don't feel it's right for me to ack this change.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
