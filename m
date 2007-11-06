Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbXKFG7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbXKFG7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXKFG7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:59:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbXKFG7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:59:37 -0500
Date: Mon, 5 Nov 2007 22:58:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: trenn@suse.de
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 1/5] Small ACPICA extension to be able to store the name
 of operation regions in osl.c later
Message-Id: <20071105225840.610943fc.akpm@linux-foundation.org>
In-Reply-To: <1193236371.4590.228.camel@queen.suse.de>
References: <1193236371.4590.228.camel@queen.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this patch introduces a compile error:

drivers/acpi/osl.c:1203: error: conflicting types for 'acpi_os_validate_address'
include/acpi/acpiosxf.h:243: error: previous declaration of 'acpi_os_validate_address' was here

which the next patch fixes.  This breaks git-bisection and will cause great
gnashing of teeth to those who hit it.

Also, please fix this:

drivers/acpi/osl.c: In function 'acpi_os_validate_address':
drivers/acpi/osl.c:1365: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'
drivers/acpi/osl.c:1365: warning: format '%s' expects type 'char *', but argument 5 has type 'long unsigned int'

it's all covered in Documentation/SubmitChecklist but it seems that
file was write-only.

<goes back to fixing build errors>
