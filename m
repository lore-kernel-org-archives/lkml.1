Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYBLHqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYBLHqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbYBLHq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:46:28 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:47569 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145AbYBLHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:46:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iU+hBdVTlrXno9q6cOXfuY7b+BqHjt1IEy5zIYV//feaIMHKvOlf0/i+kmNva0zhdtyIYj7vAhKfyejEQl4Tz0Fx6sb6cC+i9+4oHIfATV06dNQAVs4z9CPWzJ+BC1hTimaII4IvtaIODDX+MM59fD1qfhhLOcNl3tpK23rJ4Gc=
Message-ID: <804dabb00802112346q240745abm93b6257f2cd64e60@mail.gmail.com>
Date: Tue, 12 Feb 2008 15:46:23 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Scott Lovenberg" <scott.lovenberg@gmail.com>
Subject: Re: Documentation about sysfs/procfs entries
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <b1fc6a560802112217j57ab3fa1h611864a6a2423943@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00802112123t774623b2n3e1e0a4addde1512@mail.gmail.com>
	 <b1fc6a560802112217j57ab3fa1h611864a6a2423943@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 2:17 PM, Scott Lovenberg <scott.lovenberg@gmail.com> wrote:
>
> On Feb 12, 2008 12:23 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> >
> > I  was looking for documentation on the kstack_depth_to_print under
> /proc/sys/kernel, and I found it in Documentation/sysctl.txt (written by
> Rik).
> >
> > How about /proc/sys/net?   or all other directories under /sys or /proc
> fs?
> >
> > Wouldn't it be useful to have a centralized store located in Documentation
> - properly structured,  just a one-liner or two - on the reasons and
> explanations for each of these /proc or /sys parameters?   And something to
> look for further details?
> >
> > Something of the following:
> >
> > |-- netfilter
> > |   |-- nf_conntrack_buckets:your explanation here
> > |   |-- nf_conntrack_checksum:your explanation here...
> > |   |-- nf_conntrack_count
> > |   |-- nf_conntrack_expect_max
> > |   |-- nf_conntrack_generic_timeout
> > |   |-- nf_conntrack_icmp_timeout
> > |   |-- nf_conntrack_log_invalid
> > |   |-- nf_conntrack_max
> > |   |-- nf_conntrack_tcp_be_liberal
> > |   |-- nf_conntrack_tcp_loose
> > |   |-- nf_conntrack_tcp_max_retrans
> > |   |-- nf_conntrack_tcp_timeout_close
> > |   |-- nf_conntrack_tcp_timeout_close_wait
> > |   |-- nf_conntrack_tcp_timeout_established
> > |   |-- nf_conntrack_tcp_timeout_fin_wait
> > |   |-- nf_conntrack_tcp_timeout_last_ack
> > |   |-- nf_conntrack_tcp_timeout_max_retrans
> > |   |-- nf_conntrack_tcp_timeout_syn_recv
> > |   |-- nf_conntrack_tcp_timeout_syn_sent
> > |   |-- nf_conntrack_tcp_timeout_time_wait
> > |   |-- nf_conntrack_udp_timeout
> > |   `-- nf_conntrack_udp_timeout_stream
> > |-- nf_conntrack_max
> > |-- token-ring
> > |   `-- rif_timeout
> > `-- unix
> >     `-- max_dgram_qlen
> >
> >
> > Alternatively, we can write a script to extract out the partial
> explanations/details from existing source code, based on some coding
> convention/style structure, and further hand-modification from there.
> (given the dynamic nature of the kernel code, this may be preferred?)
> >
> >
>
> I was looking for exactly this about 2 weeks ago; I needed to look up the
> knobs for net and disk elevators, and had to jump all over the place.  I
> assumed that such a thing should exist, but I didn't find it.  I know I
> would personally benefit from this, and I'm sure many others would, too.

My suggestion is that since the parameters are:

a.   divide the symbols into two group:   well-documented vs
undocumented (prefixed by "__" eg, __xxxx).   this supposedly for
sysadmin vs kernel developer.

b.   for each of the official documented /sys control, provide a
one-line description when passed via /sys/help (eg, echo
kstack_depth_to_print > /sys/help) and the helpstring will go to the
console.

On the other hand, this may potentially blow up the vmlinux image size.
