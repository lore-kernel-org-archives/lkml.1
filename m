Return-Path: <linux-kernel-owner+w=401wt.eu-S1763999AbZLQEzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763999AbZLQEzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbZLQEzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:55:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758931AbZLQEzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:55:13 -0500
Message-ID: <4B29BA13.7020502@redhat.com>
Date: Wed, 16 Dec 2009 23:56:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com> <ada3a3a6xs6.fsf@roland-alpha.cisco.com>
In-Reply-To: <ada3a3a6xs6.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> 
>  >        For  example,  before the POSIX standard, to match alphanumeric charac-
>  >        ters, you would have had to write /[A-Za-z0-9]/.  If your character set
>  >        had  other  alphabetic characters in it, this would not match them, and
>  >        if your character set collated differently from ASCII, this  might  not
>  >        even match the ASCII alphanumeric characters.  With the POSIX character
>  >        classes, you can write /[[:alnum:]]/, and this matches  the  alphabetic
>  >        and numeric characters in your character set, no matter what it is.
> 
> I'm not sure I understand this, although I'm not a character set expert.
> But is there really some possible locale + awk implementation where an
> awk script, written in pure ASCII, operating on a pure ASCII input file,
> will have [A-Za-z0-9] match a different set of ASCII characters than
> [[:alnum:]] will match?

I assume that in utf-8 locale(nowadays default in most of distro) alphabets
may be sorted as aAbBcC...zZ(or AaBb...), and in this case a-z means
aAbBcC...z.

As Al Viro said, if we run awk with LC_ALL=C, then the characters will be
sorted as ASCII. So, your patch is OK if you can add LC_ALL=C just before
$(AWK). (I'm not so sure whether Makefile can accept it...)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

