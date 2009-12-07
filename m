Return-Path: <linux-kernel-owner+w=401wt.eu-S935217AbZLGO1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217AbZLGO1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935168AbZLGO1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:27:00 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935145AbZLGO1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UDEh6V3jUJscGQLH8HNz9l92bLdRVIP51mPJp5kQQDw4twfNoi2Fl29bGrBkwNr+uf
         uIySG5WFNjgn+AcS875ma1tUuI3rtQEqjYG9qYurCzrnHu/B9yP2rrd1rGNUh7lUYlT+
         Fo8WLl7Q6Ul4pjnfyyl0o0YutAAxE7TgvLWwg=
MIME-Version: 1.0
In-Reply-To: <4B1CB15F.3000403@cn.fujitsu.com>
References: <4B1CB14A.4080402@cn.fujitsu.com> <4B1CB15F.3000403@cn.fujitsu.com>
Date: Mon, 7 Dec 2009 15:27:05 +0100
Message-ID: <c62985530912070627l1ba96ce7x922ab5a2f4c93648@mail.gmail.com>
Subject: Re: [PATCH 01/13] tracing: Extract duplicate ftrace_raw_init_event_foo()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nB7ERI16018306

2009/12/7 Li Zefan <lizf@cn.fujitsu.com>:
> +static int ftrace_raw_init_event_##call(struct ftrace_event_call *event_call)\> +{                                                                      \> +       int id;                                                         \> +                                                                       \> +       id = register_ftrace_event(event_call->event);                  \> +       if (!id)                                                        \> +               return -ENODEV;                                         \> +       event_call->id = id;                                            \> +       INIT_LIST_HEAD(&event_call->fields);                            \> +       return 0;                                                       \>  }

This function doesn't vary anymore in this form.May be can we define a generic one in trace_event.c and only referencethis one?
Or even better, may be can we drop this callback field and statically call thiscode when we intialize an event. IIRC, the syscall raw_init_event has thesame callback, may be it's even the same for kprobes events (I can'tcheck right now).ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
