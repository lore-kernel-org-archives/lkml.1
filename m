Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYKBVZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYKBVZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYKBVZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:25:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37721 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYKBVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:25:23 -0500
Date: Sun, 2 Nov 2008 21:25:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: T??r??k Edwin <edwintorok@gmail.com>
Cc: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081102212512.GF28946@ZenIV.linux.org.uk>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225660694-19765-3-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 11:18:14PM +0200, T??r??k Edwin wrote:
> +static int
> +trace_seq_path(struct trace_seq *s, struct path *path)
> +{
> +	int ret;
> +	struct seq_file m;
> +	m.count = s->len;
> +	m.size = PAGE_SIZE;
> +	m.buf = s->buffer;
> +	ret = seq_path(&m, path, "\n");
> +	if (ret)
> +		s->len = m.count;
> +	return ret;
> +}

NAK.  seq_path() is a blatantly wrong thing to use here.
