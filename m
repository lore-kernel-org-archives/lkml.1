Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZK3WGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZK3WGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZK3WGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:06:49 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:58593 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZK3WGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:06:49 -0500
Message-ID: <4B1441B7.90209@oracle.com>
Date: Mon, 30 Nov 2009 14:05:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, mhiramat@redhat.com,
       wcohen@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] tracing: add DEFINE_EVENT(), DEFINE_SINGLE_EVENT() support
 to docbook
References: <200911302123.nAULNhaC019844@int-mx02.intmail.prod.int.phx2.redhat.com>
In-Reply-To: <200911302123.nAULNhaC019844@int-mx02.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B1441D3.0136:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> The introduction of the new 'DECLARE_EVENT_CLASS()' obviates the need for the
> 'TRACE_EVENT()' macro in some cases. Thus, docbook style comments that used
> to live with 'TRACE_EVENT()' are now moved to 'DEFINE_EVENT()'. Thus, we need
> to make the docbook system understand the new 'DEFINE_EVENT()' macro. In
> addition I've tried to futureproof the patch, by also adding support for
> 'DEFINE_SINGLE_EVENT()', since there has been discussion about renaming:
> TRACE_EVENT() -> DEFINE_SINGLE_EVENT().
> 
> Without this patch the tracepoint docbook fails to build.
> 
> I've verified that this patch correctly builds the tracepoint docbook which
> currently covers signals, and irqs.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
> 
>  scripts/kernel-doc |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index ea9f8a5..d1746be 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1855,6 +1855,13 @@ sub tracepoint_munge($) {
>  	if($prototype =~ m/TRACE_EVENT\((.*?),/) {
>  		$tracepointname = $1;
>  	}
> +	if($prototype =~ m/DEFINE_SINGLE_EVENT\((.*?),/) {
> +		$tracepointname = $1;
> +	}
> +	if($prototype =~ m/DEFINE_EVENT\((.*?),(.*?),/) {
> +		$tracepointname = $2;
> +	}
> +	$tracepointname =~ s/^\s+//; #strip leading whitespace
>  	if($prototype =~ m/TP_PROTO\((.*?)\)/) {
>  		$tracepointargs = $1;
>  	}

Hi,

Looks fine to me except that "if(" should be "if ("
in the old & new code.


> @@ -1920,7 +1927,9 @@ sub process_state3_function($$) {
>  	if ($prototype =~ /SYSCALL_DEFINE/) {
>  		syscall_munge();
>  	}
> -	if ($prototype =~ /TRACE_EVENT/) {
> +	if ($prototype =~ /TRACE_EVENT/ || $prototype =~ /DEFINE_EVENT/ ||
> +	    $prototype =~ /DEFINE_SINGLE_EVENT/)
> +	{
>  		tracepoint_munge($file);
>  	}
>  	dump_function($prototype, $file);


-- 
~Randy
