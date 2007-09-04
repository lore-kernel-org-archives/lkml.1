Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXIDQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXIDQ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbXIDQ4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:56:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:45711 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbXIDQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=MFLLb2BeosPFUn5c2hRXD0WqCPr8ArME/WTz3NjqSODhU6DESMVHeOjlVPK0rzU5fxRXXdiTjGfV8S5ESnGfN3P3x+8ucqaZtCJ2OA17NgyZQkgyt39bVr9k5mvtFOhcYi87+34OPaCwIZp7zdfkvDOuLvr9pcstkTympYdFGxc=
Date: Tue, 4 Sep 2007 20:56:37 +0400
To: "anon... anon.al" <anon.asdf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Race condition: calling remove_proc_entry in cleanup_module (module_exit) while someone's using procfile
Message-ID: <20070904165637.GA1905@martell.zuzino.mipt.ru>
References: <379fb4870709040939m2430be6ci57fd73f1f9abc6ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <379fb4870709040939m2430be6ci57fd73f1f9abc6ef@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 06:39:33PM +0200, anon... anon.al wrote:
> There is a race condition if an instance is executing "__exit
> device_exit" and calls remove_proc_entry, while someone is still using
> the procfile, right?.
> 
> static void __exit device_exit(void)
> {
>   // what if the procfile is still in use?
>   remove_proc_entry(PROC_FILE_NAME, &proc_root);
> }

For regular proc files, this is fixed in 2.6.23-rc1 and later.
