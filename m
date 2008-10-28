Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYJ1Mmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYJ1Mmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 08:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYJ1MmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 08:42:22 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:31430 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751988AbYJ1MmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 08:42:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EsMc8KTHGd5IPNo96PcsV4Y64YqRHjpYSnTm07ESvHc3LgUZC8iQvMGmylXtcOpTJDq+ZBVjC6zfQeaxZiDCwni13y4Pa62GPhSgHXknD4AZwz6D8JfwEnunauDVub6y/UlhJUZjw/KPCTAZ169FnHfYPIF945IxhHcF3Wj2h44=  ;
X-YMail-OSG: XXLTZeoVM1mw9HMYpU8DLduLC_RpdFPs0F2FXgxGNqe5jVvtwEmBzUmaw9rel1o7moN9KqufOEIo6FuelxptJvHfRHXdCMLW4Hw0Qwc742lHayxPG.mEDjEQ4P8vEO4EvPsTnQZsFytRSAJUWI2rRT7WCOb3.yH9Ej4EXknr7DIsSUEwPOc_RYwZoyEz
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
Date: Tue, 28 Oct 2008 23:42:04 +1100
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <4901F375.3020202@vlnb.net>
In-Reply-To: <4901F375.3020202@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810282342.05172.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 October 2008 03:10, Vladislav Bolkhovitin wrote:
> Hi,
>
> During recent debugging session of my SCSI target SCST
> (http://scst.sf.net) I noticed many
>
> WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
>
> messages in kernel log on the initiator. I attached the full log of
> several of them.
>
> My target was buggy and I was working on fixing it, but I suppose Linux
> should handle such failures more gracefully. In all the cases the target
> had one type of failure: it "ate" a SCSI command and never returned
> result of it.

Right. This is one of the warnings I see in my fault-injection testing.
It is fixed by my patch to clean up and improve the page and buffer
error handling in the vm/fs.
