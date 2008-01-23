Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYAWBx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYAWBx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYAWBxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:53:19 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:52726 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYAWBxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N/y5ZMt5Ip2h2vRNcY+pAxypPkUU6mqYZt8N6QkvtuMcKx9z33+MaS77K3MXFR86eMJWse9MS1QOs7bmofw1GI8af61ox9HFkxmyG2IxppEubSVMVzn5seTVBZ4nbQndi+3kTfT4JSYTNnm7gW1yhfaYBsabcerLHIySGwNGWZU=
Message-ID: <91b13c310801221753n4e2ca523k877fe758bed54445@mail.gmail.com>
Date: Wed, 23 Jan 2008 09:53:16 +0800
From: "rae l" <crquan@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] kernel/params.c: fix the module name length in param_sysfs_builtin
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Dave Young" <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801230011300.9183@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200906505-28859-1-git-send-email-crquan@gmail.com>
	 <200801212216.11784.rusty@rustcorp.com.au>
	 <Pine.LNX.4.64.0801230011300.9183@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23, 2008 7:13 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> But nf..dada_compat.c gets linked into nf_conntrack_ipv4.ko,
> and that is what is used in /sys/module - and it fits the 20.
> Any place where nf_conntrack_l3proto_ipv4_compat would still be used?
there is a module named nf_conntrack_proto_icmp.ko, length 23. and you
can find all them by:

$ make allmodconfig && make modules

$ find -name '*.ko' -printf '%f\n' |gawk '{print length($0), $0}' |sort -n
...
24 dvb-usb-af9005-remote.ko
24 dvb-usb-dibusb-common.ko
25 nf_conntrack_proto_gre.ko
26 nf_conntrack_netbios_ns.ko
26 nf_conntrack_proto_sctp.ko
29 nf_conntrack_proto_udplite.ko

so currently tha max length of module name is 26 (in
nf_conntrack_proto_udplite), but still no any length limit to module
names in Documentation/, so we have to prepare reserved space for
modules later, or mark MODULE_NAME_LEN as the modules' name length
limit in Documentation/?

Simply speaking, MODULE_NAME_LEN does the better job.
>

-- 
Denis Cheng
