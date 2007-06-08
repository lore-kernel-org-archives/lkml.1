Return-Path: <linux-kernel-owner+w=401wt.eu-S966960AbXFHAuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966960AbXFHAuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966210AbXFHAuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:50:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:53988 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966108AbXFHAuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gy49xK7lWGpXN8a2ZBkdIK2rXPwlhIeTaWu1PmKmNjFKPh1osAJDBHrl1op2YkdWBqIDHLAclJxwdVSL0zhkjNIvoa3zG46DMnwmkQifv2zryE6Eg2xNk6b5lrDl3+pNmUNPjpF7ITmMAVMtHNtseajbEDdpOlOLlgC+Q9Mkbqg=
Message-ID: <6934efce0706071750w66bad0d5u22b5c6eb15401a31@mail.gmail.com>
Date: Thu, 7 Jun 2007 17:50:01 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: get_xip_page() uncertainity
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to create valid "struct page* (*get_xip_page)(struct
address_space *, sector_t, int)" to use the filemap_xip.c.

I've been trying to do it as follows:

virtual = ioremap(physical,size);

struct page* my_get_xip_page(struct address_space *mapping, sector_t
sector, int create)
{
  unsigned long offset;
  /*extract offset from mapping and sector*/
  return virt_to_page(virtual + offset);
}

I believe this to be fundamentally flawed.  While this works for
xip_file_read(), it does not work for xip_file_mmap().  I'm not sure I
understand the correct way to do this.  But I assume the problem, and
have some evidence to support it, is that virt_to_page() is not
returning a vaild page struct.

How can I get a valid page struct?  The memory is not RAM but Flash.
It is addressable like RAM and I want userspace to use it like
readonly RAM.
