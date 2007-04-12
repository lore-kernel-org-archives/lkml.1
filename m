Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXDLQlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXDLQlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXDLQlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:41:05 -0400
Received: from gw1a.telemetry-investments.com ([64.20.161.180]:57526 "EHLO
	sv1.telemetry-investments.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932332AbXDLQlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:41:03 -0400
Date: Thu, 12 Apr 2007 12:09:10 -0400
From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070412160910.GA11736@ti88.telemetry-investments.com>
Mail-Followup-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
	"Christopher S. Aker" <caker@theshore.net>,
	linux-kernel@vger.kernel.org
References: <461E55C6.1030905@theshore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461E55C6.1030905@theshore.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 11:52:38AM -0400, Christopher S. Aker wrote:
> I've been trying to find a method for compressing process core dumps 
> before they hit disk.
> 
> I ask because we've got some fairly large UML processes (1GB for some), 
> and we're trying to capture dumps to help Jeff debug an evasive bug. 
> Our systems use a small root partition and most of the other disk 
> resources on the host are allocated towards the UMLs.
> 
> There are userspace solutions to this problem:  allowing the 
> uncompressed core dump to spin out to disk and then coming in afterwards 
> and doing the compression, or maybe even a compressed filesystem where 
> the core dumps land, but I just thought I'd throw this out there since 
> it seems it would be a useful feature :)

See Documentation/kernel.txt for kernels >= 2.6.19:

core_pattern:

core_pattern is used to specify a core dumpfile pattern name.
. max length 128 characters; default value is "core"
. core_pattern is used as a pattern template for the output filename;
  certain string patterns (beginning with '%') are substituted with
  their actual values.
. backward compatibility with core_uses_pid:
        If core_pattern does not include "%p" (default does not)
        and core_uses_pid is set, then .PID will be appended to
        the filename.
. corename format specifiers:
        %<NUL>  '%' is dropped
        %%      output one '%'
        %p      pid
        %u      uid
        %g      gid
        %s      signal number
        %t      UNIX time of dump
        %h      hostname
        %e      executable filename
        %<OTHER> both are dropped
. If the first character of the pattern is a '|', the kernel will treat
  the rest of the pattern as a command to run.  The core dump will be
  written to the standard input of that program instead of to a file.


Regards,

	Bill Rugolsky
