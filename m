Return-Path: <linux-kernel-owner+w=401wt.eu-S1161675AbXDXGqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161675AbXDXGqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161674AbXDXGqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:46:04 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:58596 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161675AbXDXGqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:46:02 -0400
Message-ID: <462DA74A.6090702@in.ibm.com>
Date: Tue, 24 Apr 2007 12:14:26 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Transparently handle <.symbol> lookup for kprobes
References: <200704231128.49041.srinivasa@in.ibm.com> <17965.40145.647933.480761@cargo.ozlabs.ibm.com>
In-Reply-To: <17965.40145.647933.480761@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Srinivasa Ds writes:
> 
>> +	} else {							\
>> +		char dot_name[KSYM_NAME_LEN+1];				\
>> +		dot_name[0] = '.';					\
>> +		dot_name[1] = '\0';					\
>> +		strncat(dot_name, name, KSYM_NAME_LEN);			\
> 
> Assuming the kernel strncat works like the userspace one does, there
> is a possibility that dot_name[] won't be properly null-terminated
> here.  If strlen(name) >= KSYM_NAME_LEN-1, then strncat will set
> dot_name[KSYM_NAME_LEN-1] to something non-null and won't touch
> dot_name[KSYM_NAME_LEN].

Irrespective of length of the string, kernel implementation of
strncat(lib/string.c) ensures that last character of string is set to
null. So dot_name[] is always null terminated.

========================
char *strncat(char *dest, const char *src, size_t count)
{
        char *tmp = dest;

        if (count) {
                while (*dest)
                        dest++;
                while ((*dest++ = *src++) != 0) {
                        if (--count == 0) {
                                *dest = '\0';
                                break;
                        }
                }
        }
        return tmp;
}
EXPORT_SYMBOL(strncat);
===============================

Is this OK then ??


Thanks
 Srinivasa DS

> 
> Paul.

