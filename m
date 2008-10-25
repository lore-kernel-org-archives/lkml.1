Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbYJYT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbYJYT4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYJYT4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 15:56:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:24410 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYJYTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 15:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MOlYviMQAGjUWkrPYepZrKFSGIe+W5rkJQSlFmlTqoWCkZZQhgZZMYqNCQRJtXzv82
         XZH0V4+0sTHFtX/TZXwj6vF6cOxz0hokp6KIID5Y5rZ44h1ZFVtodMMey9iC6rgi/biY
         Gm0oGBlAartOJCKzACpyYpUn4FT133fpw1znA=
Message-ID: <86802c440810251255ncbbed09l9404c03406c61f05@mail.gmail.com>
Date: Sat, 25 Oct 2008 12:55:59 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: mathieu.taillefumier@free.fr
Subject: Re: [Bug] pci allocation resources problems on x86_64
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1224938637.4903148d28cfc@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49019FE4.50001@free.fr> <4901A4C2.5020805@free.fr>
	 <200810241131.55129.jbarnes@virtuousgeek.org>
	 <1224879041.49022bc1562bb@imp.free.fr>
	 <86802c440810250145qa09a9ay919203055f8e85f0@mail.gmail.com>
	 <1224938637.4903148d28cfc@imp.free.fr>
X-Google-Sender-Auth: 63574ee0f2d96842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 5:43 AM,  <mathieu.taillefumier@free.fr> wrote:
> Hi,
>
> It is not possible to modify anything from the bios at least nothing related to
> memory. So what do you suggest forcing the pci_mem_start. When I look at the
> dmesg file I find some open windows such as 0xc0000001 -> 0xdfffffff and
> 0xf0000001 -> to 0xfebffffff or something like that.

your BIOS only leave 0xc0000000 - 0xc7ffffff for kernel to allocate
that to unassigned resource.

and your device for bus 0x0a need 0x4000000 for mmio and 0x4000000 for
pref mmio.

but 1f.3 is not assigned resource too, need to make sure if it really
need to assigned resource by OS too...
kernel should allocate 0xca00000 to it..., so simplely use quirks to disable it.

YH
