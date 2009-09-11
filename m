Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZIKOIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZIKOIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZIKOIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:08:18 -0400
Received: from fifo99.com ([67.223.236.141]:47307 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbZIKOIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:08:17 -0400
Subject: Re: [PATCH 8/8] fanotify: send events to userspace over socket
 reads
From: Daniel Walker <dwalker@fifo99.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, viro@zeniv.linux.org.uk,
       alan@linux.intel.com, hch@infradead.org
In-Reply-To: <20090911052649.32359.18553.stgit@paris.rdu.redhat.com>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
	 <20090911052649.32359.18553.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 07:08:50 -0700
Message-Id: <1252678130.30578.848.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 01:26 -0400, Eric Paris wrote:
> fanotify sends event notification to userspace when userspace reads from the
> fanotify socket. This patch implements the operations that happen at read
> time.  These include opening the file descriptor to the original object and
> then filling the userspace buffer.  The fd should be pollable to indicate when
> it has data present and it should return how much data it has to send when the
> FIONREAD ioctl is checked.
> 

This patch has one checkpatch error, could you fix that? .. Also your
whole series has several very long lines over 80 characters , you might
want to consider trimming those down to 80 or less.. If you run these
patches through checkpatch you should output like the following denoting
the issues,

ERROR: "(foo*)" should be "(foo *)"
#381: FILE: include/linux/fanotify.h:84:
+                                  (struct fanotify_event_metadata*)(((char *)(meta)) + \

WARNING: line over 80 characters
#384: FILE: include/linux/fanotify.h:87:
+#define FAN_EVENT_OK(meta, len)        ((long)(len) >= (long)FAN_EVENT_METADATA_LEN && \


Daniel

