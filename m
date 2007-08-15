Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbXHOGh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbXHOGh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 02:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXHOGhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 02:37:47 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:32817 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750876AbXHOGhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 02:37:46 -0400
Message-ID: <387159861.30846@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 14:37:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
Subject: Re: [patch 2/2] Sort module list by pointer address to get
	coherent sleepable seq_file iterators
Message-ID: <20070815063741.GB5175@mail.ustc.edu.cn>
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815041845.GJ21089@ftp.linux.org.uk>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 05:18:45AM +0100, Al Viro wrote:
>> On Wed, Aug 15, 2007 at 11:39:45AM +0800, Fengguang Wu wrote:
>> seqfile: remove seq_file's assumption about iterators
>> 
>> The seq_file implementation has some hardcoded index++/pos++ lines,
>> which assumes iterators to be *continuous* integers.
>
>What the fuck?  It assumes no such thing and a lot of iterators are
>nothing like integers.  What are you talking about?

Oh I used the wrong term...

Take for example this function from lwn.net:

static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
{
        loff_t *spos = (loff_t *) v;
        *pos = ++(*spos);
        return spos;
}

I mean 'pos' is sometimes increased in ct_seq_next(), and sometimes from
seq_file.c/seq_read(), too. Thus we cannot reliably do this:

        *pos = (*spos) + some_variable_offset;


You are referring to spos as the iterator, are you?

Maybe I'm wrong. I'll dip more into it.

