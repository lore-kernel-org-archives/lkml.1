Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZBJVLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZBJVLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZBJVLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:11:34 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:27188 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZBJVLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:11:34 -0500
MIME-Version: 1.0
In-Reply-To: <56e1b5710902050026s5a8fd48fhf4a65c05a533dbc3@mail.gmail.com>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <20090204221451.GA27254@uranus.ravnborg.org>
	 <adavdrplty2.fsf@cisco.com> <498A295A.4090008@gmail.com>
	 <adaskmtjsnn.fsf@cisco.com>
	 <56e1b5710902050026s5a8fd48fhf4a65c05a533dbc3@mail.gmail.com>
Date: Tue, 10 Feb 2009 16:11:30 -0500
Message-ID: <f73f7ab80902101311w30d5aecet6dd7c2123a671480@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Kyle Moffett <kyle@moffetthome.net>
To: Floris Kraak <randakar@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 3:26 AM, Floris Kraak <randakar@gmail.com> wrote:
> There are probably some real bugs in there. On the other hand there is
> some overhead to fixing the warnings. Kernel text size increase,
> possibly some CPU overhead from parsing the format string. Hopefully
> none of these calls are in really hot code paths ;-)

Actually, I would really suspect that CPU time would *decrease* for
most of these, because instead of groveling through the whole argument
string looking for '%' symbols we would do a single "%s" lookup
followed by a basic strncpy(dmesg_buffer + offset, arg,
dmesg_buffer_size - offset);

Cheers,
Kyle Moffett
