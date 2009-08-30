Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZH3OdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZH3OdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 10:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZH3OdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 10:33:11 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:51597 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZH3OdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 10:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=KwvI+0wfxBeOohL6BwOD2LLRpm3VrsC9YJKHO1EUjBuvUc1N+KJtBY6lWzar1rWejQ
         s7Amqc/vQSdolyfI1GaS6Y6JYg9eeNQj1Zl9FjqEIusfpTmgHPhCTd5jekxaiBMq6uL2
         VtwTaDCKQc1TpYLk5P5cmOCuxKPp47IkmhyPA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata_piix: parallel scanning on PATA needs an extra locking
Date: Sun, 30 Aug 2009 16:33:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200908301456.30132.bzolnier@gmail.com> <20090830151321.57bc33eb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090830151321.57bc33eb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200908301633.19978.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 August 2009 16:13:21 Alan Cox wrote:
> > Lets fix all such races by adding an extra locking to ->set_piomode
> > and ->set_dmamode methods for PATA controllers.
> 
> Would it not be better to take the host lock in libata-core for these
> cases so that we fix all the adapters in one swoop. Even if we are doing
> this lock taking in the controller specific code it seems the right lock
> to use ?

Yes, taking the host lock would be a preferred solution in the long-term
and would allow us to enable parallel scanning for many other controllers
later.

The downside is that it requires somebody to audit all host drivers before
making such change and much more testing time..

> Looks fine as a temproary quickfix tho

That was the goal of the patch (I verified the issue only yesterday).
