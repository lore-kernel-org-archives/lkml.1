Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZEZP2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZEZP2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZEZP23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:28:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358AbZEZP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:28:28 -0400
Subject: Re: [PATCH -tip][SCSI] scsi: scsi_transport_iscsi.c initialize the
	variable before it get used
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1243351161.31783.5.camel@localhost.localdomain>
References: <1243351161.31783.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Tue, 26 May 2009 10:28:29 -0500
Message-Id: <1243351709.2815.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 20:49 +0530, Jaswinder Singh Rajput wrote:
> I am watching this problem from long time in -tip.
> 
> Subject: [PATCH] scsi: scsi_transport_iscsi.c initialize the variable before it get used
> 
> In some cases, err will be used uninitialized.

What cases?  A simple theoretical analysis shows that this variable is
always set.

>  CC      drivers/scsi/scsi_transport_iscsi.o
> drivers/scsi/scsi_transport_iscsi.c: In function ‘iscsi_add_session’:
> drivers/scsi/scsi_transport_iscsi.c:678: warning: ‘err’ may be used
> uninitialized in this function

My version of gcc (4.3.3) correctly sees that the variable cannot be
uninitialised ... what version are you using?

If it's a popular version, we can always do the uninitialised_var()
thing, but if it's just a non-standard compiler, I'd rather not mess up
the source code to please gcc.

James


