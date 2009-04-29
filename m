Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZD2SKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZD2SKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZD2SKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:10:13 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:60128 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbZD2SKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:10:12 -0400
Message-ID: <49F897F4.6080006@oracle.com>
Date: Wed, 29 Apr 2009 11:09:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       wcohen@redhat.com
Subject: Re: [PATCH 2/3] add new tracepoints docbook
References: <200904291745.n3THjTUe019540@ns3.rdu.redhat.com>
In-Reply-To: <200904291745.n3THjTUe019540@ns3.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49F897AB.000D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> Add tracepoint docbook. This will help us document and understand
> what tracepoints are in the kernel. Since there are multiple
> macros, and files that contain tracepoints.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  Documentation/DocBook/Makefile        |    3 +-
>  Documentation/DocBook/tracepoint.tmpl |   84 +++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/DocBook/tracepoint.tmpl
> 
> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index 8918a32..4c8f4d6 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -13,7 +13,8 @@ DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
>  	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
>  	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
>  	    mac80211.xml debugobjects.xml sh.xml regulator.xml \
> -	    alsa-driver-api.xml writing-an-alsa-driver.xml
> +	    alsa-driver-api.xml writing-an-alsa-driver.xml \
> +	    tracepoint.xml
>  
>  ###
>  # The build process is as follows (targets):
> diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
> new file mode 100644
> index 0000000..2639a8b
> --- /dev/null
> +++ b/Documentation/DocBook/tracepoint.tmpl
> @@ -0,0 +1,84 @@
> +<?xml version="1.0" encoding="UTF-8"?>
> +<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
> +	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
> +
> +<book id="Tracepoints">
> + <bookinfo>
> +  <title>The Linux Kernel Tracepoint API</title>
> +
> +  <authorgroup>
> +   <author>
> +    <firstname>Jason</firstname>
> +    <surname>Baron</surname>
> +    <affiliation>
> +     <address>
> +      <email>jbaron@redhat.com</email>
> +     </address>
> +    </affiliation>
> +   </author>
> +  </authorgroup>
> +
> +  <legalnotice>
> +   <para>
> +     This documentation is free software; you can redistribute
> +     it and/or modify it under the terms of the GNU General Public
> +     License as published by the Free Software Foundation; either
> +     version 2 of the License, or (at your option) any later
> +     version.
> +   </para>
> +
> +   <para>
> +     This program is distributed in the hope that it will be
> +     useful, but WITHOUT ANY WARRANTY; without even the implied
> +     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> +     See the GNU General Public License for more details.
> +   </para>
> +
> +   <para>
> +     You should have received a copy of the GNU General Public
> +     License along with this program; if not, write to the Free
> +     Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> +     MA 02111-1307 USA
> +   </para>
> +
> +   <para>
> +     For more details see the file COPYING in the source
> +     distribution of Linux.
> +   </para>
> +  </legalnotice>
> + </bookinfo>
> +
> + <toc></toc>
> +  <chapter id="intro">
> +   <title>Introduction</title>
> +   <para>
> +     Tracepoints are static probe points that are located in strategic points
> +     throughout the kernel. 'Probes' register/unregister with tracepoints
> +     via a callback mechanism. The 'probes' are strictly typed functions that
> +     are passed a unique set of parameters defined by each tracepoint.
> +   </para>
> +
> +   <para>
> +     From this simple callback mechanism, 'probes' can be used to profile, debug,
> +     and understand kernel behavior. There are a number of tools that provide a
> +     framework for using 'probes'. These tools include Systemtap, ftrace, and
> +     LTTng.
> +   </para>
> +
> +   <para>
> +     Tracepoints are defined in a number of header files via various macros. Thus,
> +     the purpose of this document is to provide a clear accounting of the available
> +     tracepoints. The intention is to understand not only what tracepoints are
> +     available but also to understand where future tracepoints might be added.
> +   </para>
> +
> +   <para>
> +     The api presented has functions of the form:

	    API                  please

otherwise, looks good.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> +     <function>trace_tracepointname(function parameters)</function>. These are the
> +     tracepoints callbacks that are found throughout the code. Registering and
> +     unregistering probes with these callback sites is covered in the
> +     <filename>Documentation/trace/*</filename> directory.
> +   </para>
> +  </chapter>
> +
> +</book>


-- 
~Randy
