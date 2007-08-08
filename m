Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbXHHLzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbXHHLzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXHHLzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:55:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42354 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbXHHLzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:55:36 -0400
Date: Wed, 8 Aug 2007 13:55:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sheplyakov Alexei <varg@theor.jinr.ru>
Cc: Andi Kleen <andi@firstfloor.org>, dragoran <drago01@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070808115535.GB13878@one.firstfloor.org>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <20070808095132.GA31020@theor.jinr.ru> <20070808102056.GC12861@one.firstfloor.org> <20070808114949.GA8465@theor.jinr.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808114949.GA8465@theor.jinr.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The original question (unless I'm missing something) was "why _the owner_
> of a process is not enabled to lower its IO priority?" The owner of the
> process certainly can send signal and ptrace it.

Ah I misparsed you.

Sending signals and ptraces is atomic regarding system operations. This means
the kernel will finish doing whatever it is doing (or bail out releasing
all resources) before processing them. So stopping a process this
way can never starve its IO.  Ok there are special cases like user space
FUSE or NFS servers that can block operations, but these are expected to run 
as root.

-Andi
