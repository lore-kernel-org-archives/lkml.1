Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZIUF21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZIUF21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 01:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbZIUF20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 01:28:26 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:51188 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZIUF2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 01:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RA8ud3fh6JSunfBQsb87Ph4JakSLMDbkQN+DGGv///CpWeNNmpYssCqkYAM4BfVnK9
         im+WwJThNoM1Y8NstJUlUy2P+Hxr99zDwjVgDTXWtOVtGhSIxcsFK6J4o5E5zDGq3cDt
         4pn5ehk4uhYo+WyTnJwF8DKQkTKjfAjAvRAaE=
MIME-Version: 1.0
In-Reply-To: <3e73e7360909180317s1094585i5c8edc1f35d2ad20@mail.gmail.com>
References: <3e73e7360909171940r4de1021bj25db1ff28f5b3262@mail.gmail.com>
	 <3e73e7360909171941s47853514x9867f5f796c82e8@mail.gmail.com>
	 <3e73e7360909180317s1094585i5c8edc1f35d2ad20@mail.gmail.com>
Date: Mon, 21 Sep 2009 12:28:29 +0700
Message-ID: <f284c33d0909202228p78e8c554nd8f67493b200a5c2@mail.gmail.com>
Subject: Re: How can i see whether a process id is alive?
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
To: Driver-Seeker <linuxdriverforme@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 5:17 PM, Driver-Seeker
<linuxdriverforme@gmail.com> wrote:
> Hi
>
>   I have a small question...
> I have the process id of an application.. I have to verify whether that
> process is alive or not from kernel space. How can i do that? do we have any
> such API's like isAlive(pid) ? [but googling didnt give me anything:(]

What do you mean by "alive"? Runnable state? All in all, I think you
can use find_task_by_vpid() function defined in linux/sched.h. It
needs one parameter: the pid of a task you're searching for and it
will return its task struct. There, you can check the state property.

Mind you that now PID are organized under namespace to accomodate
virtualization environment and I have no idea how to deal with this
new PID namespace schema. But looking at the find_task_by_vpid()
function implementation, it is a safe bet since it will use the same
namespace as the caller.

-- 
regards,

Mulyadi Santosa
Freelance Linux trainer
blog: the-hydra.blogspot.com
